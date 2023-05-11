(include "gnap_uci_macros.lisp")

; Roles
; CI
(defmacro (ROLE_CI
        ci pk_ci ch_ci_as ch_ci_eu ch_ci_rs
        as_cont_token_rand as_token_rand pk_as ch_as_ci
        eu_code
        rs rs_access rs_data ch_rs_ci
    ) (^
        ; CI .. AS
        (send ch_ci_as (CI_AS_1 ci pk_ci rs rs_access))
        (recv ch_as_ci (AS_CI_2 ci pk_ci as_cont_token_rand pk_as eu_code rs rs_access))
        
        ; CI .. EU
        (send ch_ci_eu (CI_EU_3 eu_code))

        ; CI .. AS
        (send ch_ci_as (CI_AS_11 ci pk_ci as_cont_token_rand pk_as rs rs_access))
        (recv ch_as_ci (AS_CI_12 ci pk_ci as_token_rand pk_as rs rs_access))
        
        ; CI .. RS
        (send ch_ci_rs (CI_RS_13 ci pk_ci as_token_rand pk_as rs rs_access))
        (recv ch_rs_ci (RS_CI_14 ci pk_ci as_token_rand pk_as rs rs_access rs_data))
    )
)

; AS
(defmacro (ROLE_AS
        ci pk_ci ch_ci_as
        as as_cont_token_rand as_token_rand pk_as ch_as_ci ch_as_eu
        eu eu_code eu_code_status ch_eu_as
        rs rs_access
    ) (^
        ; AS .. CI
        (recv ch_ci_as (CI_AS_1 ci pk_ci rs rs_access))
        (send ch_as_ci (AS_CI_2 ci pk_ci as_cont_token_rand pk_as eu_code rs rs_access))

        ; AS .. EU (RO)
        (recv ch_eu_as (EU_AS_4_5_6_8 as eu eu_code))
        (send ch_as_eu (EU_AS_7 as eu eu_code_status))

        ; AS .. CI
        (recv ch_ci_as (CI_AS_11 ci pk_ci as_cont_token_rand pk_as rs rs_access))
        (send ch_as_ci (AS_CI_12 ci pk_ci as_token_rand pk_as rs rs_access))
    )
)

; EU
(defmacro (ROLE_EU
        ch_ci_eu
        as ch_as_eu
        eu eu_code eu_code_status ch_eu_as
    ) (^
        ; CI .. EU
        (recv ch_ci_eu (CI_EU_3 eu_code))

        ; EU .. AS
        (send ch_eu_as (EU_AS_4_5_6_8 as eu eu_code))
        (recv ch_as_eu (EU_AS_7 as eu eu_code_status))
    )
)

; RS
(defmacro (ROLE_RS
        ci pk_ci ch_ci_rs
        as_token_rand pk_as
        rs rs_access rs_data ch_rs_ci
    ) (^
        ; RS .. CI
        (recv ch_ci_rs (CI_RS_13 ci pk_ci as_token_rand pk_as rs rs_access))
        (send ch_rs_ci (RS_CI_14 ci pk_ci as_token_rand pk_as rs rs_access rs_data))
    )
)
