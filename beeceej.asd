;;;; blog.beeceej.com.asd

(asdf:defsystem #:beeceej
  :description "package BEECEEJ is everything to do with beeceej.com"
  :author "Brian Jones <beeceej.code@gmail.com>"
  :license  "MIT"
  :version "0.0.1"
  :serial t
  :depends-on (#:cl-markdown
               #:cl-json
               #:drakma
               #:yason
               #:3bmd
               #:3bmd-ext-tables
               #:3bmd-ext-code-blocks
               #:xhtmlambda
               #:cl-who
               #:colorize)
  :components ((:file "package")
               (:file "js")
               (:file "app")
               (:file "api")
               (:file "nav")
               (:file "beeceej")
               (:file "blog-post")
               ))
