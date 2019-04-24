;;;; blog.beeceej.com.asd

(asdf:defsystem #:blog.beeceej.com
  :description "Describe blog.beeceej.com here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:cl-markdown #:cl-json #:drakma #:yason)
  :components ((:file "package")
               (:file "blog.beeceej.com")))
