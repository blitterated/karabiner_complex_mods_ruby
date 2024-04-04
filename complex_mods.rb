#!/usr/bin/env ruby

require 'json'

class KarabinerComplexMod

  private

    def build_apple_keyboard_conditions
      [
        {
          :type => "device_if",
          :identifiers => [
            {
              :vendor_id => 1452
            },
            {
              :product_id => 835
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
        :to => [to_target],
        :to_if_alone => [to_if_alone_target]
      }
      
      conditions = build_apple_keyboard_conditions
      hash[:conditions] = conditions unless conditions.nil?
      hash
    end

    def build_capslock_to_esc_and_control_rule

      from_target =        build_manipulator_target(:caps_lock, {:optional => ["any"]})
      to_target =          build_manipulator_target(:left_control)
      to_if_alone_target = build_manipulator_target(:escape)
      
      {
        :description => "MBP Only: CapsLock is Esc on tap, Ctrl on mod",
        :manipulators => [
          build_basic_to_if_alone_manipulator(
            from_target, to_target, to_if_alone_target
          )
        ]
      }
    end

    def build_shift_keys_parens_on_tap_rule

      l_target =       build_manipulator_target(:left_shift)
      l_alone_target = build_manipulator_target("9", [:left_shift])
      r_target =       build_manipulator_target(:right_shift)
      r_alone_target = build_manipulator_target("0", [:right_shift])

      {
        :description => "MBP Only: Shift keys are parens on tap",
        :manipulators => [
          build_basic_to_if_alone_manipulator(l_target, l_target, l_alone_target),
          build_basic_to_if_alone_manipulator(r_target, r_target, r_alone_target)
        ]
      }
    end

    def build_shift_key_manipulator_targets(shift_key_code, to_key_code)      
      opposite_shift_key_code = 
        case shift_key_code
        when :left_shift;   :right_shift
        when :right_shift;  :left_shift
        else ;              throw "Not a shift key: #{shift_key_code}"
        end
      
      from_mods = {:mandatory => [opposite_shift_key_code], :optional => [to_key_code]}
      from =      build_manipulator_target(shift_key_code, from_mods)
      to =        build_manipulator_target(to_key_code)
      alone =     build_manipulator_target(shift_key_code)
      
      [from, to, alone]
    end

    def build_both_shifts_to_capslock_rule
          
      l_from, l_to , l_alone = build_shift_key_manipulator_targets(:left_shift, :caps_lock) 
      r_from, r_to , r_alone = build_shift_key_manipulator_targets(:right_shift, :caps_lock) 

      {
        :description => "MBP Only: LS + RS = CapsLock",
        :manipulators => [
          build_basic_to_if_alone_manipulator(l_from, l_to, l_alone),
          build_basic_to_if_alone_manipulator(r_from, r_to, r_alone)
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