#!/usr/bin/env ruby

require 'json'

class Hash
  def store_local_var(key, vsymbol, caller_binding)
    return nil unless caller_binding.local_variable_defined?(vsymbol)
    
    value = caller_binding.local_variable_get(vsymbol)
    self.store(key,value)
    self
  end
end

# TODO: 835 is actually "product_id"
apple_keyboard_conditions = [
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


complex_mods = {
  :title => "Only modify Macbook Pro built in keyboard",
  :rules => [
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
        }.store_local_var(:conditions, :apple_keyboard_conditions, binding)
      ]
    },
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
        }.store_local_var(:conditions, :apple_keyboard_conditions, binding),
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
        }.store_local_var(:conditions, :apple_keyboard_conditions, binding)
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
        }.store_local_var(:conditions, :apple_keyboard_conditions, binding),
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
        }.store_local_var(:conditions, :apple_keyboard_conditions, binding)
      ]
    }
  ]
}

puts JSON.pretty_generate complex_mods