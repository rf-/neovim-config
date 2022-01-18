#!/usr/bin/env fish

for file in fnl/**/*.fnl
  echo $file
  fnlfmt --fix --body-forms module,augroup! --fn-forms defn,defn- $file
end
