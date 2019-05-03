(in-package #:beeceej)

(defclass app ()
  ((components :accessor components :initform '() :initarg :components)))

(defun render-components (obj)
  "render-components takes an app object
and renders all of it's components left to right into a string
we do this to ensure each component is rendered correctly"
  (with-output-to-string (out-string)
    (loop
      :for component in (components obj)
      do (format out-string "~a" (render component)))
    out-string ))

(defvar tmpjs (make-instance 'javascript
                             :raw *index-javascript*))

(defmethod render ((obj app))
  (with-output-to-string (out-string)
    (cl-who:with-html-output (out-string)
      (cl-who:htm
       (:html
        (:head
         (:meta :charset :utf-8)
         (:style
          (cl-who:str *index-css*)
          (cl-who:str colorize:*coloring-css*)))
        (:body (cl-who:str (render-components obj)))
        (:script (cl-who:str *index-javascript*)))))))

(defmethod print-object ((obj app) out)
  (let ((fmt-string "~a"))
    (print-unreadable-object (obj out :type t)
      (format out fmt-string (components obj)))))


;; (cl-who:with-html-output (*standard-output*)
;;   (cl-who:htm (:script (cl-who:str "asdf"))))
