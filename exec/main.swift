import Foundation
import PKI

let pwd = FileManager.default.currentDirectoryPath
//Logger.v("Running in \(pwd)")


// ------ Self-signed root
let rootPrivateKey = "root.priv.key"
let rootPublicKey = "root.pub.key"
let rootCertFile = "root_cert.pem"

KeyPairGenerator.generate(privateKeyFilename: rootPrivateKey, 
                          publicKeyFilename: rootPublicKey,
                          publicKeyFormat: .pem)

// Generate self-signed x509 certificate
let rootInfo = CertificateInfo(countryName: "PL",
                               stateOrProvinceName: "lodzkie",
                               localityName: "Lodz",
                               organizationName: "Certificate Root IT Company",
                               organizationalUnitName: nil,
                               commonName: "IT Root CA 1",
                               alternativeNames: [])
SelfSignedCertGenerator.generate(using: rootInfo,
                                 privateKeyFilename: rootPrivateKey,
                                 x509Output: rootCertFile,
                                 outputFormat: .pem,
                                 expiration: .years(10))

//Logger.v("CA x509 file: \(pwd)/\(rootCertFile)")

// intermediate cert
let intermediatePrivateKey = "intermediate.priv.key"
let intermediatePublicKey = "intermediate.pub.key"
let intermediateCSRFile = "intermediate_csr.cer"
let intermediateCertFile = "intermediate_cert.pem"

ECCKeyPairGenerator.generate(privateKeyFilename: intermediatePrivateKey,
                             publicKeyFilename: intermediatePublicKey,
                             publicKeyFormat: .pem)

// Generate Certificate Signing Request
let intermediateInfo = CertificateInfo(countryName: "EN",
                                       stateOrProvinceName: "British",
                                       localityName: "London",
                                       organizationName: "Certificate Seller Company",
                                       organizationalUnitName: nil,
                                       commonName: "Intermediate M01",
                                       alternativeNames: [])
CSRGenerator.generate(using: intermediateInfo, 
                      type: .intermediate,
                      privateKeyFilename: intermediatePrivateKey,
                      csrOutput: intermediateCSRFile)



// process CSR by self-signed root

let rootAuthority = CertificateAuthority(caPrivateKeyFilename: rootPrivateKey,
                                         caX509Filename: rootCertFile)
// create intermediate x509 certificate
rootAuthority.processCSRAddingExtensions(csrFilename: intermediateCSRFile,
                                         x509Output: intermediateCertFile,
                                         outputFormat: .pem,
                                         expiration: .years(10))


// ------ end user cert
let userPrivateKey = "user.priv.key"
let userPublicKey = "user.pub.key"
let userCSRFile = "user_csr.cer"
let userCertFile = "user_cert.pem"

KeyPairGenerator.generate(privateKeyFilename: userPrivateKey, 
                          publicKeyFilename: userPublicKey,
                          publicKeyFormat: .der)

// Generate Certificate Signing Request
let userInfo = CertificateInfo(countryName: "DE",
                             stateOrProvinceName: "Central Germany",
                             localityName: "Berlin",
                             organizationName: "German Research Center",
                             organizationalUnitName: nil,
                             commonName: "research.com",
                             alternativeNames: ["*.research.com"])
CSRGenerator.generate(using: userInfo,
                      type: .endUser,
                      privateKeyFilename: userPrivateKey,
                      csrOutput: userCSRFile)



// process CSR by self-signed root

let intermediateAuthority = CertificateAuthority(caPrivateKeyFilename: intermediatePrivateKey,
                                                 caX509Filename: intermediateCertFile)
intermediateAuthority.processCSRAddingExtensions(csrFilename: userCSRFile,
                                                 x509Output: userCertFile,
                                                 outputFormat: .pem,
                                                 expiration: .years(1))


print("\(X509Certificate(path: rootCertFile)?.prettyPrint ?? "")")
print("\(X509Certificate(path: intermediateCertFile)?.prettyPrint ?? "")")
print("\(X509Certificate(path: userCertFile)?.prettyPrint ?? "")")

