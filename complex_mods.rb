#!/usr/bin/env ruby

complex_mods = %Q({
  "title": "Only modify Macbook Pro built in keyboard",
  "rules": [
    {
      "description": "MBP Only: CapsLock is Esc on tap, Ctrl on mod",
      "manipulators": [
        {
          "type": "basic",
          "from": {
            "key_code": "caps_lock",
            "modifiers": {
              "optional": [
                "any"
              ]
            }
          },
          "to": [
            {
              "key_code": "left_control"
            }
          ],
          "to_if_alone": [
            {
              "key_code": "escape"
            }
          ],
          "conditions": [
            {
              "type": "device_if",
              "identifiers": [
                {
                  "vendor_id": 1452
                },
                {
                  "vendor_id": 835
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "description": "MBP Only: Shift keys are parens on tap",
      "manipulators": [
        {
          "type": "basic",
          "from": {
            "key_code": "left_shift"
          },
          "to": [
            {
              "key_code": "left_shift"
            }
          ],
          "to_if_alone": [
            {
              "key_code": "9",
              "modifiers": [
                "left_shift"
              ]
            }
          ],
          "conditions": [
            {
              "type": "device_if",
              "identifiers": [
                {
                  "vendor_id": 1452
                },
                {
                  "vendor_id": 835
                }
              ]
            }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "right_shift"
          },
          "to": [
            {
              "key_code": "right_shift"
            }
          ],
          "to_if_alone": [
            {
              "key_code": "0",
              "modifiers": [
                "right_shift"
              ]
            }
          ],
          "conditions": [
            {
              "type": "device_if",
              "identifiers": [
                {
                  "vendor_id": 1452
                },
                {
                  "vendor_id": 835
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "description": "MBP Only: LS + RS = CapsLock",
      "manipulators": [
        {
          "type": "basic",
          "from": {
            "key_code": "left_shift",
            "modifiers": {
              "mandatory": [
                "right_shift"
              ],
              "optional": [
                "caps_lock"
              ]
            }
          },
          "to": [
            {
              "key_code": "caps_lock"
            }
          ],
          "to_if_alone": [
            {
              "key_code": "left_shift"
            }
          ],
          "conditions": [
            {
              "type": "device_if",
              "identifiers": [
                {
                  "vendor_id": 1452
                },
                {
                  "vendor_id": 835
                }
              ]
            }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "right_shift",
            "modifiers": {
              "mandatory": [
                "left_shift"
              ],
              "optional": [
                "caps_lock"
              ]
            }
          },
          "to": [
            {
              "key_code": "caps_lock"
            }
          ],
          "to_if_alone": [
            {
              "key_code": "right_shift"
            }
          ],
          "conditions": [
            {
              "type": "device_if",
              "identifiers": [
                {
                  "vendor_id": 1452
                },
                {
                  "vendor_id": 835
                }
              ]
            }
          ]
        }
      ]
    }
  ]
})

puts complex_mods