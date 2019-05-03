(in-package #:beeceej)

(defclass javascript ()
  ((raw :initarg :raw :accessor raw)))

(defmethod render ((obj javascript))
  (with-output-to-string (out-string)
    (xhtmlambda:with-html-syntax-output
        (out-string)
        (cl-who:htm (:script (cl-who:str (raw obj)))))))

(defmethod print-object ((obj javascript) out)
  (print-unreadable-object (obj out :type t)
    (format out "~a" (raw obj))))


