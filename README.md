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
