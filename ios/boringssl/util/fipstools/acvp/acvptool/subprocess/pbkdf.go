// Copyright 2024 The BoringSSL Authors
//
// Permission to use, copy, modify, and/or distribute this software for any
// purpose with or without fee is hereby granted, provided that the above
// copyright notice and this permission notice appear in all copies.
//
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
// SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
// OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
// CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

package subprocess

import (
	"encoding/hex"
	"encoding/json"
	"fmt"
)

// The following structures reflect the JSON of ACVP PBKDF tests. See
// https://pages.nist.gov/ACVP/draft-celi-acvp-pbkdf.html#name-test-vectors

type pbkdfTestVectorSet struct {
	Groups []pbkdfTestGroup `json:"testGroups"`
	Mode   string           `json:"mode"`
}

type pbkdfTestGroup struct {
	ID       uint64 `json:"tgId"`
	Type     string `json:"testType"`
	HmacAlgo string `json:"hmacAlg"`
	Tests    []struct {
		ID             uint64 `json:"tcId"`
		KeyLen         uint32 `json:"keyLen,omitempty"`
		Salt           string `json:"salt,omitempty"`
		Password       string `json:"password,omitempty"`
		IterationCount uint32 `json:"iterationCount,omitempty"`
	} `json:"tests"`
}

type pbkdfTestGroupResponse struct {
	ID    uint64              `json:"tgId"`
	Tests []pbkdfTestResponse `json:"tests"`
}

type pbkdfTestResponse struct {
	ID         uint64 `json:"tcId"`
	DerivedKey string `json:"derivedKey,omitempty"`
}

// pbkdf implements an ACVP algorithm by making requests to the
// subprocess to generate PBKDF2 keys.
type pbkdf struct{}

func (p *pbkdf) Process(vectorSet []byte, m Transactable) (any, error) {
	var parsed pbkdfTestVectorSet
	if err := json.Unmarshal(vectorSet, &parsed); err != nil {
		return nil, err
	}

	var ret []pbkdfTestGroupResponse
	// See
	// https://pages.nist.gov/ACVP/draft-celi-acvp-pbkdf.html#name-test-vectors
	// for details about the tests.
	for _, group := range parsed.Groups {
		group := group

		// "There is only one test type: functional tests."
		// https://pages.nist.gov/ACVP/draft-celi-acvp-pbkdf.html#section-6.1
		if group.Type != "AFT" {
			return nil, fmt.Errorf("test type %q in test group %d not supported", group.Type, group.ID)
		}

		response := pbkdfTestGroupResponse{
			ID: group.ID,
		}

		for _, test := range group.Tests {
			test := test

			if test.KeyLen < 8 {
				return nil, fmt.Errorf("key length must be at least 8 bits in test case %d/%d", group.ID, test.ID)
			}
			keyLen := uint32le(test.KeyLen)

			salt, err := hex.DecodeString(test.Salt)
			if err != nil {
				return nil, fmt.Errorf("failed to decode hex salt in test case %d/%d: %s", group.ID, test.ID, err)
			}

			if test.IterationCount < 1 {
				return nil, fmt.Errorf("iteration count must be at least 1 in test case %d/%d", group.ID, test.ID)
			}
			iterationCount := uint32le(test.IterationCount)

			msg := [][]byte{[]byte(group.HmacAlgo), keyLen, salt, []byte(test.Password), iterationCount}
			m.TransactAsync("PBKDF", 1, msg, func(result [][]byte) error {
				response.Tests = append(response.Tests, pbkdfTestResponse{
					ID:         test.ID,
					DerivedKey: hex.EncodeToString(result[0]),
				})
				return nil
			})
		}

		m.Barrier(func() {
			ret = append(ret, response)
		})
	}

	if err := m.Flush(); err != nil {
		return nil, err
	}

	return ret, nil
}