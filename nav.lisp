
(in-package #:beeceej)

(defclass nav ()
  ((nav-headers
    :accessor nav-headers
    :initform '(("About" . "/") ("Thoughts" . "/blog")))
   (nav-icons
    :accessor nav-icons
    :initform '(("LinkedIn" . "https://www.linkedin.com/in/beeceej/")
                ("Twitter" . "https://www.twitter.com/_beeceej")
                ("Github" . "https://github.com/beeceej")))))


(defmethod render ((obj nav))
  "render writes the html to a string-stream"
  (with-output-to-string (out-string)
    (xhtmlambda:with-html-syntax-output
        (out-string)
        (flet ((make-link (label ref) (xhtmlambda:a (:class "clickable" :href ref) (string label))))
          (xhtmlambda:nav
           (:class "navigation")
           (xhtmlambda:div
            (:class "flexContainer") (loop :for (label . ref) in (nav-headers obj)
                     collect (make-link label ref )))
           (xhtmlambda:div
            (:class "flexContainer") (loop :for (label . ref) in (nav-icons obj)
                     collect (make-link label ref ))))))))

(defmethod print-object ((obj nav) out)
  (let ((fmt-string ":headers ~a :icons ~a"))
    (print-unreadable-object (obj out :type t)
      (format out fmt-string
              (nav-headers obj)
              (nav-icons obj)))))
