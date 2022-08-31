# https://stackoverflow.com/questions/44055029/how-to-generate-a-certificate-using-pyopenssl-to-make-it-secure-connection
import os
from OpenSSL import crypto


# echo "generating ca.key"


#     openssl genrsa -out "${WORK_DIR}/certs/ca.key" 2048
#     openssl rsa -in "${WORK_DIR}/certs/ca.key" -out "${WORK_DIR}/certs/ca.key.rsa"
#     openssl req -new -key "${WORK_DIR}/certs/ca.key.rsa" -subj /CN=local.kubify.local -out "${WORK_DIR}/certs/ca.csr" -config "${K8S_DIR}/certs/kubify-cli-gen-certs.conf"
#     openssl x509 -req -extensions v3_req -days 3650 -in "${WORK_DIR}/certs/ca.csr" -signkey "${WORK_DIR}/certs/ca.key.rsa" -out "${WORK_DIR}/certs/ca.crt" -extfile "${K8S_DIR}/certs/kubify-cli-gen-certs.conf"

#     if [[ "$OSTYPE" == *"darwin"* ]]; then
#        sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain "${WORK_DIR}/certs/ca.crt" || true
#     elif [[ "$OSTYPE" == *"linux"* ]]; then
#       if [[ "$ACTUAL_OS_TYPE" == "ubuntu" ]] || [[ "$ACTUAL_OS_TYPE" == "debian" ]]; then
#        # NOTE: TODO?: Might also have to also add to the browsers (linux/windows): https://unix.stackexchange.com/questions/90450/adding-a-self-signed-certificate-to-the-trusted-list
#        apt-get install -y ca-certificates || sudo apt-get install -y ca-certificates
#        # normally cacert.pem
#        mkdir -p /usr/share/ca-certificates
#        rm -f /usr/share/ca-certificates/kubify_ca.crt
#        sudo update-ca-certificates --fresh
#        cp "${WORK_DIR}/certs/ca.crt" /usr/share/ca-certificates/kubify_ca.crt
#        sudo update-ca-certificates || true
#       fi
#       if [[ "$ACTUAL_OS_TYPE" == "centos" ]]; then
#         #TODO" https://support.kerioconnect.gfi.com/hc/en-us/articles/360015200119-Adding-Trusted-Root-Certificates-to-the-Server
#        yum install -y ca-certificates
#        update-ca-trust force-enable
#        mkdir -p /etc/pki/ca-trust/source/anchors
#        rm -f /etc/pki/ca-trust/source/anchors/kubify_ca.crt
#        cp "${WORK_DIR}/certs/ca.crt" /etc/pki/ca-trust/source/anchors/kubify_ca.crt
#        update-ca-trust extract || sudo update-ca-trust extract || true
#       fi
#     fi

# fi


def create_signed_cert(cn, settings, models):
    CA_KEY_FILE = os.path.join(settings.ROOT_CRT_PATH, "rootCA.key")
    CA_CERT_FILE = os.path.join(settings.ROOT_CRT_PATH, "rootCA.crt")

    ca_cert = crypto.load_certificate(
        crypto.FILETYPE_PEM,
        open(os.path.join(settings.MEDIA_ROOT, CA_CERT_FILE)).read(),
    )

    ca_key = crypto.load_privatekey(
        crypto.FILETYPE_PEM, open(os.path.join(settings.MEDIA_ROOT, CA_KEY_FILE)).read()
    )

    k = crypto.PKey()
    k.generate_key(crypto.TYPE_RSA, 2048)

    cert_req = crypto.X509Req()

    cert_req.get_subject().C = models.RootCrt.objects.first().country
    cert_req.get_subject().ST = models.RootCrt.objects.first().state
    cert_req.get_subject().L = models.RootCrt.objects.first().location
    cert_req.get_subject().O = models.RootCrt.objects.first().organization
    if models.RootCrt.objects.first().organizational_unit_name:
        cert_req.get_subject().OU = (
            models.RootCrt.objects.first().organizational_unit_name
        )
    cert_req.get_subject().CN = cn
    if models.RootCrt.objects.first().email:
        cert_req.get_subject().emailAddress = models.RootCrt.objects.first().email

    cert_req.set_pubkey(k)
    cert_req.sign(ca_key, "sha256")

    cert = crypto.X509()
    cert.gmtime_adj_notBefore(0)
    cert.gmtime_adj_notAfter(5 * 365 * 24 * 60 * 60)
    cert.set_issuer(ca_cert.get_subject())
    cert.set_subject(cert_req.get_subject())
    cert.set_pubkey(cert_req.get_pubkey())
    cert.sign(ca_key, "sha256")
