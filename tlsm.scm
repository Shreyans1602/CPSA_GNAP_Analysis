(herald "TLS 1.2 with macro file")

(include "tls_macros.lisp")

(defprotocol tls basic

  (defrole client
    (vars (s ca name) (cr sr pms text) (pks akey))
    (trace
     (TLSclient_nocerts cr sr pms s pks ca))
    (non-orig (privk ca)))

  (defrole server
    (vars (s ca name) (cr sr pms text) (pks akey))
    (trace
     (TLSserver_nocertreq cr sr pms s pks ca))
    ;  (send (enc "message" (ServerWriteKey (MasterSecret pms cr sr))))
    ;  (recv (enc "client's_message" (ClientWriteKey (MasterSecret pms cr sr))))
    (non-orig (privk ca))))

(defskeleton tls
  (vars (s ca name) (cr pms text) (pks akey))
  (defstrand client 6 (s s) (cr cr) (pms pms) (pks pks))
  (non-orig (invk pks))
  (uniq-orig cr pms)
  )

(defskeleton tls
  (vars (s name) (sr text) (pks akey))
  (defstrand server 5 (s s) (sr sr) (pks pks))
  (non-orig (invk pks))
  (uniq-orig sr)
  )

(defskeleton tls
  (vars (s name) (cr pms text) (pks akey))
  (defstrand client 6 (s s) (cr cr) (pms pms) (pks pks))
  (deflistener pms)
  (non-orig (invk pks))
  (uniq-orig cr pms)
  )