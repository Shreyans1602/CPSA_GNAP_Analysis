(include "gnap_uci_macros.lisp")
(include "tls_macros.lisp")

; Utils
(defmacro (tls_client_send r_c r_s pms msg)
    (send (enc msg (ClientWriteKey (MasterSecret pms r_c r_s)))))

(defmacro (tls_client_recv r_c r_s pms msg)
    (recv (enc msg (ServerWriteKey (MasterSecret pms r_c r_s)))))

(defmacro (tls_server_send r_c r_s pms msg)
    (send (enc msg (ServerWriteKey (MasterSecret pms r_c r_s)))))

(defmacro (tls_server_recv r_c r_s pms msg)
    (recv (enc msg (ClientWriteKey (MasterSecret pms r_c r_s)))))

; Roles
; CI
(defmacro (ROLE_CI ca
        ci pk_ci r_ci_as r_ci_rs pms_ci_as pms_ci_rs access
        as pk_as r_as_ci cont_access_token access_token
        ch_eu user_code
        rs pk_rs r_rs_ci rs_data
    ) (^
        ; CI .. AS
        (TLSclient_nocerts r_ci_as r_as_ci pms_ci_as as pk_as ca)
        (tls_client_send r_ci_as r_as_ci pms_ci_as (CI_AS_1 ci access pk_ci))
        (tls_client_recv r_ci_as r_as_ci pms_ci_as (AS_CI_2 user_code cont_access_token))
        
        ; CI .. EU
        (send ch_eu (CI_EU_3 user_code))

        ; CI .. AS
        (tls_client_send r_ci_as r_as_ci pms_ci_as (CI_AS_11 cont_access_token pk_ci))
        (tls_client_recv r_ci_as r_as_ci pms_ci_as (AS_CI_12 access_token))
        
        ; CI .. RS
        (TLSclient_nocerts r_ci_rs r_rs_ci pms_ci_rs rs pk_rs ca)
        (tls_client_send r_ci_rs r_rs_ci pms_ci_rs (CI_RS_13 access_token pk_ci))
        (tls_client_recv r_ci_rs r_rs_ci pms_ci_rs (RS_CI_14 rs_data))
    )
)

; AS
(defmacro (ROLE_AS ca
        ci pk_ci r_ci_as pms_ci_as access
        as pk_as r_as_ci r_as_eu cont_access_token access_token
        eu r_eu_as pms_eu_as user_code user_code_status
    ) (^
        ; AS .. CI
        (TLSserver_nocertreq r_ci_as r_as_ci pms_ci_as as pk_as ca)
        (tls_server_recv r_ci_as r_as_ci pms_ci_as (CI_AS_1 ci access pk_ci))
        (tls_server_send r_ci_as r_as_ci pms_ci_as (AS_CI_2 user_code cont_access_token))

        ; AS .. EU (RO)
        (TLSserver_nocertreq r_eu_as r_as_eu pms_eu_as as pk_as ca)
        (tls_server_recv r_eu_as r_as_eu pms_eu_as (EU_AS_4_5_6_8 eu as user_code))
        (tls_server_send r_eu_as r_as_eu pms_eu_as (EU_AS_7 eu as user_code_status))

        ; AS .. CI
        (tls_server_recv r_ci_as r_as_ci pms_ci_as (CI_AS_11 cont_access_token pk_ci))
        (tls_server_send r_ci_as r_as_ci pms_ci_as (AS_CI_12 access_token))
    )
)

; EU
(defmacro (ROLE_EU ca
        as pk_as r_as_eu
        eu r_eu_as pms_eu_as ch_eu user_code user_code_status
    ) (^
        ; CI .. EU
        (recv ch_eu (CI_EU_3 user_code))

        ; EU .. AS
        (TLSclient_nocerts r_eu_as r_as_eu pms_eu_as as pk_as ca)
        (tls_client_send r_eu_as r_as_eu pms_eu_as (EU_AS_4_5_6_8 eu as user_code))
        (tls_client_recv r_eu_as r_as_eu pms_eu_as (EU_AS_7 eu as user_code_status))
    )
)

; RS
(defmacro (ROLE_RS ca
        pk_ci r_ci_rs pms_ci_rs access_token
        rs pk_rs r_rs_ci rs_data
    ) (^
        ; RS .. CI
        (TLSserver_nocertreq r_ci_rs r_rs_ci pms_ci_rs rs pk_rs ca)
        (tls_server_recv r_ci_rs r_rs_ci pms_ci_rs (CI_RS_13 access_token pk_ci))
        (tls_server_send r_ci_rs r_rs_ci pms_ci_rs (RS_CI_14 rs_data))
    )
)
