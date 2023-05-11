(herald "Simple Send-Receive")

(defprotocol send_receive basic
    
    (defrole client
        (vars (c s name) (k skey))
        (trace
            (send (cat c k))
            (recv (cat s k))
        )
    )

    (defrole server
        (vars (c s name) (k skey))
        (trace
            (recv (cat c k))
            (send (cat s k))
        )
    )
)

(defskeleton send_receive
    (vars (c s name) (k skey))
    (defstrandmax client (c c) (s s) (k k))
    (uniq-orig k)
)

(defskeleton send_receive
    (vars (c s name) (k skey))
    (defstrandmax server (c c) (s s) (k k))
    (uniq-orig k)
)

(defskeleton send_receive
    (vars (c s name) (k skey))
    (defstrandmax client (c c) (s s) (k k))
    (defstrandmax server (c c) (s s) (k k))
    (uniq-orig k)
)
