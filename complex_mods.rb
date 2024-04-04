#!/usr/bin/env ruby

require 'json'

class KarabinerComplexMod

  private

    def add_hash_node(key, method, hash)
       return hash unless self.private_methods.include?(method)
       hash[key] = send method
       hash
    end

    # TODO: 835 is actually "product_id"
    def apple_keyboard_conditions
      [
        {
          :type => "device_if",
          :identifiers => [
            {
              :vendor_id => 1452
            },
            {
              :vendor_id => 835
            }
          ]
        }
      ]
    end

    def capslock_to_esc_and_control_rule
      {
        :description => "MBP Only: CapsLock is Esc on tap, Ctrl on mod",
        :manipulators => [
          {
            :type => "basic",
            :from => {
              :key_code => "caps_lock",
              :modifiers => {
                :optional => [
                  "any"
                ]
              }
            },
            :to => [
              {
                :key_code => "left_control"
              }
            ],
            :to_if_alone => [
              {
                :key_code => "escape"
              }
            ]
          }.then { |h| add_hash_node(:conditions, :apple_keyboard_conditions, h) }
        ]
      }
    end

  public

    def generate
      {
        :title => "Only modify Macbook Pro built in keyboard",
        :rules => [
          capslock_to_esc_and_control_rule,
          {
            :description => "MBP Only: Shift keys are parens on tap",
            :manipulators => [
              {
                :type => "basic",
                :from => {
                  :key_code => "left_shift"
                },
                :to => [
                  {
                    :key_code => "left_shift"
                  }
                ],
                :to_if_alone => [
                  {
                    :key_code => "9",
                    :modifiers => [
                      "left_shift"
                    ]
                  }
                ],
              }.then { |h| add_hash_node(:conditions, :apple_keyboard_conditions, h) },
              {
                :type => "basic",
                :from => {
                  :key_code => "right_shift"
                },
                :to => [
                  {
                    :key_code => "right_shift"
                  }
                ],
                :to_if_alone => [
                  {
                    :key_code => "0",
                    :modifiers => [
                      "right_shift"
                    ]
                  }
                ],
              }.then { |h| add_hash_node(:conditions, :apple_keyboard_conditions, h) }
            ]
          },
          {
            :description => "MBP Only: LS + RS = CapsLock",
            :manipulators => [
              {
                :type => "basic",
                :from => {
                  :key_code => "left_shift",
                  :modifiers => {
                    :mandatory => [
                      "right_shift"
                    ],
                    :optional => [
                      "caps_lock"
                    ]
                  }
                },
                :to => [
                  {
                    :key_code => "caps_lock"
                  }
                ],
                :to_if_alone => [
                  {
                    :key_code => "left_shift"
                  }
                ],
              }.then { |h| add_hash_node(:conditions, :apple_keyboard_conditions, h) },
              {
                :type => "basic",
                :from => {
                  :key_code => "right_shift",
                  :modifiers => {
                    :mandatory => [
                      "left_shift"
                    ],
                    :optional => [
                      "caps_lock"
                    ]
                  }
                },
                :to => [
                  {
                    :key_code => "caps_lock"
                  }
                ],
                :to_if_alone => [
                  {
                    :key_code => "right_shift"
                  }
                ],
              }.then { |h| add_hash_node(:conditions, :apple_keyboard_conditions, h) }
            ]
          }
        ]
      }
    end
end

puts JSON.pretty_generate(KarabinerComplexMod.new.generate)