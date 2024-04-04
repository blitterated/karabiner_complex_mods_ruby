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
    def build_apple_keyboard_conditions
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

    def build_manipulator_target(keycode, modifiers = nil)
      hash = {:key_code => keycode}
      hash[:modifiers] = modifiers unless modifiers.nil?
      hash
    end

    def build_basic_to_if_alone_manipulator (
      from_target,
      to_target,
      to_if_alone_target
    )
      hash = {
        :type => "basic",
        :from => from_target,
        :to => to_target,
        :to_if_alone => to_if_alone_target
      }
      
      conditions = build_apple_keyboard_conditions
      hash[:conditions] = conditions unless conditions.nil?
      hash
    end

    def build_capslock_to_esc_and_control_rule

      from_target =        build_manipulator_target(:caps_lock, {:optional => ["any"]})
      to_target =          [build_manipulator_target(:left_control)]
      to_if_alone_target = [build_manipulator_target(:escape)]
      
      {
        :description => "MBP Only: CapsLock is Esc on tap, Ctrl on mod",
        :manipulators => [
          build_basic_to_if_alone_manipulator(
            from_target, to_target, to_if_alone_target
          )
        ]
      }
    end

    def build_shift_keys_parens_on_tap_manipulator(from_key_code, to_key_code)
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
        add_hash_node(:conditions, :build_apple_keyboard_conditions, h)
      end
    end

    def build_shift_keys_parens_on_tap_rule
      {
        :description => "MBP Only: Shift keys are parens on tap",
        :manipulators => [
          build_shift_keys_parens_on_tap_manipulator(:left_shift, "9"),
          build_shift_keys_parens_on_tap_manipulator(:right_shift, "0")
        ]
      }
    end

    def build_shift_to_capslock_manipulator(shift_key_code)
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
        add_hash_node(:conditions, :build_apple_keyboard_conditions, h)
      end
    end

    def build_both_shifts_to_capslock_rule
      {
        :description => "MBP Only: LS + RS = CapsLock",
        :manipulators => [
          build_shift_to_capslock_manipulator(:left_shift),
          build_shift_to_capslock_manipulator(:right_shift)
        ]
      }
    end

  public

    def build_complex_mod
      {
        :title => "Only modify Macbook Pro built in keyboard",
        :rules => [
          build_capslock_to_esc_and_control_rule,
          build_shift_keys_parens_on_tap_rule,
          build_both_shifts_to_capslock_rule
        ]
      }
    end
end

puts JSON.pretty_generate(KarabinerComplexMod.new.build_complex_mod)