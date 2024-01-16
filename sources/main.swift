import Foundation

let pwd = FileManager.default.currentDirectoryPath
Logger.v("Running in \(pwd)")


// ------ Self-signed root
let caPrivateKey = "ca.priv.key"
let caPublicKey = "ca.pub.key"
let caX509Cert = "ca.pem"

KeyPairGenerator.generate(privateKeyFilename: caPrivateKey, publicKeyFilename: caPublicKey)

// Generate self-signed x509 certificate
let caInfo = CertificateInfo(countryName: "PL",
                             stateOrProvinceName: "lodzkie",
                             localityName: "Lodz",
                             organizationName: "SmartCode",
                             organizationalUnitName: nil,
                             commonName: "SmartCode Root CA 5",
                             alternativeNames: [])
SelfSignedCertGenerator.generate(using: caInfo,
                                 privateKeyFilename: caPrivateKey,
                                 x509Output: caX509Cert,
                                 format: .pem)

Logger.v("CA x509 file: \(pwd)/\(caX509Cert)")


// ------ end user cert
let userPrivateKey = "user.priv.key"
let userPublicKey = "user.pub.key"
let csrFile = "csr.cer"

KeyPairGenerator.generate(privateKeyFilename: userPrivateKey, publicKeyFilename: userPublicKey)

// Generate Certificate Signing Request
let userInfo = CertificateInfo(countryName: "DE",
                             stateOrProvinceName: "Central Germany",
                             localityName: "Berlin",
                             organizationName: "DESY",
                             organizationalUnitName: nil,
                             commonName: "desy.de",
                             alternativeNames: ["*.desy.de"])
CSRGenerator.generate(using: userInfo, type: .intermediate, privateKeyFilename: userPrivateKey, csrOutput: csrFile)



// process CSR by self-signed root

let certificateAuthority = CertificateAuthority(caX509Filename: caX509Cert,
                                                caPrivateKeyFilename: caPrivateKey)
certificateAuthority.handleExtendend(csrFilename: csrFile, x509Output: "signed.pem", format: .der)

//print(Shell().exec("openssl x509 -in signed.pem -noout -text"))

//print("\(X509Certificate(path: caX509Cert)?.prettyPrint ?? "")")
print("\(X509Certificate(path: "signed.pem")?.prettyPrint ?? "")")

