```
swift build && .build/debug/PKIApp
```

## Preview x509 certificate
Both DER and PEM format are supported.
```swift
X509Certificate(path: "certificate.cer")?.prettyPrint
```

## Converting PEM x509 certificate to DER
```swift
CertificateConverter(certFilename: "certificate.pem").saveAs(derFilename: "certificate.der")
```

## Converting DER x509 certificate to PEM
```swift
CertificateConverter(certFilename: "certificate.der").saveAs(pemFilename: "certificate.pem")
```

## Converting public PEM key to DER
```swift
// first create a new private - public keys:
KeyPairGenerator.generate(privateKeyFilename: "private.key",
                          publicKeyFilename: "public.key",
                          publicKeyFormat: .pem)
// now convert publicDER key to PEM format:
PublicKeyConverter(publicKeyFilename: "public.key").saveAs(derFilename: "public.der")
```

## Converting public DER key to PEM
```swift
// first create a new private - public keys:
KeyPairGenerator.generate(privateKeyFilename: "private.key",
                          publicKeyFilename: "public.key",
                          publicKeyFormat: .der)
// now convert publicDER key to PEM format:
PublicKeyConverter(publicKeyFilename: "public.key").saveAs(pemFilename: "public.pem")
```

## How to generate Root self-signed x509 certificate

```swift
let rootPrivateKey = "root.priv.key"
let rootPublicKey = "root.pub.key"
let rootCertFile = "root_cert.pem"

// first generate private-public keys
KeyPairGenerator.generate(privateKeyFilename: rootPrivateKey, 
                          publicKeyFilename: rootPublicKey,
                          publicKeyFormat: .pem)

// define data needed for x509 certificate
let rootInfo = CertificateInfo(countryName: "PL",
                               stateOrProvinceName: "lodzkie",
                               localityName: "Lodz",
                               organizationName: "Certificate Root IT Company",,
                               commonName: "IT Root CA 1")
// Generate self-signed x509 certificate
SelfSignedCertGenerator.generate(using: rootInfo,
                                 privateKeyFilename: rootPrivateKey,
                                 x509Output: rootCertFile,
                                 outputFormat: .pem,
                                 expiration: .years(10))
// create CertificateAuthority instance needed for further processing CSRs
let rootAuthority = CertificateAuthority(caPrivateKeyFilename: rootPrivateKey,
                                         caX509Filename: rootCertFile)
```

## How to generate Intermediate x509 certificate
```swift
let intermediatePrivateKey = "intermediate.priv.key"
let intermediatePublicKey = "intermediate.pub.key"
let intermediateCSRFile = "intermediate_csr.cer"
let intermediateCertFile = "intermediate_cert.pem"

// let's create private-public keys using elliptic curves
ECCKeyPairGenerator.generate(privateKeyFilename: intermediatePrivateKey,
                             publicKeyFilename: intermediatePublicKey,
                             publicKeyFormat: .pem)

// prepare data for Certificate Signing Request
let intermediateInfo = CertificateInfo(organizationName: "Certificate Seller Company",
                                       commonName: "Intermediate M01")
// generate Certificate Signing Request
CSRGenerator.generate(using: intermediateInfo, 
                      type: .intermediate,
                      privateKeyFilename: intermediatePrivateKey,
                      csrOutput: intermediateCSRFile)
// create intermediate x509 certificate
rootAuthority.processCSRAddingExtensions(csrFilename: intermediateCSRFile,
                                         x509Output: intermediateCertFile,
                                         outputFormat: .pem,
                                         expiration: .years(3))
// create CertificateAuthority instance used later for processing end user CSRs
let intermediateAuthority = CertificateAuthority(caPrivateKeyFilename: intermediatePrivateKey,
                                                 caX509Filename: intermediateCertFile)
```

## How to generate End-user x509 certificate
```swift
let userPrivateKey = "user.priv.key"
let userPublicKey = "user.pub.key"
let userCSRFile = "user_csr.cer"
let userCertFile = "user_cert.pem"

// generate private-public keys for end user
KeyPairGenerator.generate(privateKeyFilename: userPrivateKey, 
                          publicKeyFilename: userPublicKey,
                          publicKeyFormat: .der)

// fill data for Certificate Signing Request
let userInfo = CertificateInfo(countryName: "DE",
                             stateOrProvinceName: "Central Germany",
                             localityName: "Berlin",
                             organizationName: "German Research Center",
                             commonName: "research.com",
                             alternativeNames: ["research.com", "*.research.com"])
// generate Certificate Signing Request
CSRGenerator.generate(using: userInfo,
                      type: .endUser,
                      privateKeyFilename: userPrivateKey,
                      csrOutput: userCSRFile)
// use intermediate authority to process CSR
intermediateAuthority.processCSRAddingExtensions(csrFilename: userCSRFile,
                                                 x509Output: userCertFile,
                                                 outputFormat: .pem,
                                                 expiration: .months(6))
```
