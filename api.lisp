;;;; api.lisp

(in-package #:beeceej)

(defvar *static-beeceej-url* "https://static.beeceej.com")
(defvar *all-posts-url* (format nil "~a/posts/all.json" *static-beeceej-url*))

(defun post-url (name)
  (let ((post-url-without-id
          (format nil "~a/posts" *static-beeceej-url*)))
    (format nil "~a/~a.json" post-url-without-id name)))


(defun get-all-posts ()
  (let ((stream (drakma:http-request *all-posts-url* :want-stream t)))
    (utf-8-stream stream)
    (yason:parse stream :object-as :alist)))

(defun get-post (name)
  (let ((stream (drakma:http-request
                 (format nil "https://static.beeceej.com/posts/~a.json" name)
                 :want-stream t)))
    (utf-8-stream stream)
    (yason:parse stream :object-as :alist)))


(defun utf-8-stream (stream)
  (setf (flexi-streams:flexi-stream-external-format stream) :utf-8))

