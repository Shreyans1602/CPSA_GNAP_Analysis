(include "gnap_soa_macros.lisp")

; Roles
; CI
(defmacro (ROLE_CI
        ci ci_key ch_ci_as ch_ci_rs
        as_token_rand pk_as ch_as_ci
        rs rs_access rs_data ch_rs_ci
    ) (^
        ; CI .. AS
        (send ch_ci_as (CI_AS_1 ci ci_key rs rs_access))
        (recv ch_as_ci (AS_CI_2 ci ci_key as_token_rand pk_as rs rs_access))
        
        ; CI .. RS
        (send ch_ci_rs (CI_RS_3 ci ci_key as_token_rand pk_as rs rs_access))
        (recv ch_rs_ci (RS_CI_4 ci ci_key as_token_rand pk_as rs rs_access rs_data))
    )
)

; AS
(defmacro (ROLE_AS
        ci ci_key ch_ci_as
        as_token_rand pk_as ch_as_ci
        rs rs_access
    ) (^
        ; AS .. CI
        (recv ch_ci_as (CI_AS_1 ci ci_key rs rs_access))
        (send ch_as_ci (AS_CI_2 ci ci_key as_token_rand pk_as rs rs_access))
    )
)

; RS
(defmacro (ROLE_RS
        ci ci_key ch_ci_rs
        as_token_rand pk_as
        rs rs_access rs_data ch_rs_ci
    ) (^
        ; RS .. CI
        (recv ch_ci_rs (CI_RS_3 ci ci_key as_token_rand pk_as rs rs_access))
        (send ch_rs_ci (RS_CI_4 ci ci_key as_token_rand pk_as rs rs_access rs_data))
    )
)
