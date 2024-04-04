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
              :key_code => :caps_lock,
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
          }.then do |h|
              add_hash_node(:conditions, :apple_keyboard_conditions, h)
          end
        ]
      }
    end

    def shift_keys_parens_on_tap_manipulator(from_key_code, to_key_code)
      {
        :type => "basic",
        :from => {
          :key_code => from_key_code
        },
        :to => [
          {
            :key_code => from_key_code
          }
        ],
        :to_if_alone => [
          {
            :key_code => to_key_code,
            :modifiers => [
              from_key_code
            ]
          }
        ],
      }.then do |h|
        add_hash_node(:conditions, :apple_keyboard_conditions, h)
      end
    end

    def shift_keys_parens_on_tap_rule
      {
        :description => "MBP Only: Shift keys are parens on tap",
        :manipulators => [
          shift_keys_parens_on_tap_manipulator(:left_shift, "9"),
          shift_keys_parens_on_tap_manipulator(:right_shift, "0")
        ]
      }
    end

    def both_shifts_to_capslock_manipulator(shift_key_code)
      {
        :type => "basic",
        :from => {
          :key_code => shift_key_code,
          :modifiers => {
            :mandatory => [
              case shift_key_code
              when :left_shift;   :right_shift
              when :right_shift;  :left_shift
              else ;              throw "Not a shift key: #{shift_key_code}"
              end
            ],
            :optional => [
              :caps_lock
            ]
          }
        },
        :to => [
          {
            :key_code => :caps_lock
          }
        ],
        :to_if_alone => [
          {
            :key_code => shift_key_code
          }
        ],
      }.then do |h|
        add_hash_node(:conditions, :apple_keyboard_conditions, h)
      end
    end

    def both_shifts_to_capslock_rule
      {
        :description => "MBP Only: LS + RS = CapsLock",
        :manipulators => [
          both_shifts_to_capslock_manipulator(:left_shift),
          both_shifts_to_capslock_manipulator(:right_shift)
        ]
      }
    end

  public

    def generate
      {
        :title => "Only modify Macbook Pro built in keyboard",
        :rules => [
          capslock_to_esc_and_control_rule,
          shift_keys_parens_on_tap_rule,
          both_shifts_to_capslock_rule
        ]
      }
    end
end

puts JSON.pretty_generate(KarabinerComplexMod.new.generate)