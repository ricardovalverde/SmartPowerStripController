import CommonCrypto
import CryptoKit
import Foundation

struct GenerateSignatureRequest {
    let token: String?
    let httpMethod: String
    let url: String
}

struct SignatureData {
    let timestamp: String
    let nonce: String
    let signature: String
    let token: String?
}

func getTimestamp13() -> String {
    // Timestamp em milissegundos
    let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
    return String(timestamp)
}

func getNonce() -> String {
    return UUID().uuidString
}

func hmacSHA256Sign(message: String, secret: String) -> String {
    let keyData = Data(secret.utf8)
    let messageData = Data(message.utf8)
    var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))

    keyData.withUnsafeBytes { keyBytes in
        messageData.withUnsafeBytes { messageBytes in
            CCHmac(
                CCHmacAlgorithm(kCCHmacAlgSHA256),
                keyBytes.baseAddress,
                keyData.count,
                messageBytes.baseAddress,
                messageData.count,
                &digest
            )
        }
    }

    let hmacData = Data(digest)
    return hmacData.map { String(format: "%02X", $0) }.joined()  // Hex uppercase
}

func createStringToSign(httpMethod: String, contentSHA256: String, url: String)
    -> String
{
    return
        "\(httpMethod.uppercased())\n\(contentSHA256)\n\n\(url.replacingOccurrences(of: "\r", with: ""))"
}

func sha256(data: Data) -> String {
    let hashed = SHA256.hash(data: data)
    return hashed.map { String(format: "%02x", $0) }.joined()
}

func generateSignatureWithoutToken(
    signatureStructureRequest: GenerateSignatureRequest
) -> SignatureData {

    let timestamp = getTimestamp13()
    let nonce = getNonce()

    let contentSHA256 =
        "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

    let stringToSign = createStringToSign(
        httpMethod: signatureStructureRequest.httpMethod,
        contentSHA256: contentSHA256,
        url: signatureStructureRequest.url
    )
    let signPayload =
        Credentials.clientId! + timestamp + nonce + stringToSign

    let strToSign = signPayload

    let signature = hmacSHA256Sign(
        message: strToSign,
        secret: Credentials.clientSecret!
    )

    return SignatureData(
        timestamp: timestamp,
        nonce: nonce,
        signature: signature,
        token:nil,
    )
}


func generateSignatureWithToken(
    signatureStructureRequest: GenerateSignatureRequest,
    jsonData: Data
) -> SignatureData {
    
    let bodyHash = sha256(data: jsonData)
    let timestamp = getTimestamp13()
    let nonce = getNonce()
    let method = signatureStructureRequest.httpMethod
    let url = signatureStructureRequest.url
    let token = signatureStructureRequest.token!

    let stringToSign = createStringToSign(
        httpMethod: method,
        contentSHA256: bodyHash,
        url: url
    )

    let signPayload =
        Credentials.clientId! + token + timestamp
        + nonce + stringToSign
    
    let signature = hmacSHA256Sign(
        message: signPayload,
        secret: Credentials.clientSecret!
    )

    return SignatureData(
        timestamp: timestamp,
        nonce: nonce,
        signature: signature,
        token: token
    )
}
