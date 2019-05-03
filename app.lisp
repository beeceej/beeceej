(in-package #:beeceej)

(defclass app ()
  ((components :accessor components :initform '() :initarg :components)))

(defmethod render ((obj app))
  (with-output-to-string (out-string)
                  (cl-who:with-html-output (out-string)
                    (cl-who:htm
                     (:html
                      (:head
                       (:meta :charset :utf-8)
                       (:style
                        (cl-who:str *index-css*)
                        (cl-who:str colorize:*coloring-css*))
                       (:script (cl-who:str *index-javascript*)))
                      (cl-who:str (loop
                                    :for component in (components obj)
                                    collect (format out-string "~a" (render component)))))))))

(defmethod print-object ((obj app) out)
  (let ((fmt-string "~a"))
    (print-unreadable-object (obj out :type t)
      (format out fmt-string (components obj)))))

