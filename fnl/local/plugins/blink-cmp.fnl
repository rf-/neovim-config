(local blink-cmp (require :blink.cmp))

(blink-cmp.setup {:completion {:list {:selection {:preselect false
                                                  :auto_insert true}}
                               :menu {:draw {:gap 2}}
                               :documentation {:auto_show true
                                               :auto_show_delay_ms 500}
                               :ghost_text {:enabled true}}
                  :keymap {:preset "enter" :<C-k> false}
                  :signature {:enabled true}})
