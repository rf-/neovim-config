(local {:line get-line-number
        :col get-col-number
        :synID syn-id
        :synIDattr syn-id-attr
        :synIDtrans syn-id-trans} vim.fn)

(local {: popen} io)

(fn system [cmd]
  "Run the given command and return its output."
  (let [handle (popen (.. cmd " 2>&1"))
        result (handle:read :*all)]
    (handle.close)
    result))

(fn inspect-syntax-group []
  "Return a string summarizing the syntax groups at the current cursor position."
  (let [line-number (get-line-number ".")
        col-number (get-col-number ".")]
    (.. :hi< (syn-id-attr (syn-id line-number col-number 1) :name) "> trans<"
        (syn-id-attr (syn-id line-number col-number 0) :name) "> lo<"
        (syn-id-attr (syn-id-trans (syn-id line-number col-number 1)) :name) ">")))

{: system : inspect-syntax-group}
