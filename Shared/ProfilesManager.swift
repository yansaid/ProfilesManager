//
//  ProfilesManager.swift
//  Profiles
//
//  Created by Yan on 2020/12/11.
//

import Foundation

class ProfilesManager: ObservableObject {
    @Published var profiles = [ProvisioningProfile]()
    @Published var loading = false
    
    init() {
        reload()
    }
    
    func reload() {
        guard let libraryDirectoryURL = libraryDirectoryURL() else {
            return
        }
        loading = true
        DispatchQueue.global().async {
            let fileManager = FileManager.default
            let profilesDirectoryURL = libraryDirectoryURL.appendingPathComponent("/MobileDevice/Provisioning Profiles")
            let enumerator = fileManager.enumerator(at: profilesDirectoryURL,
                                                    includingPropertiesForKeys: [.nameKey],
                                                    options: .skipsHiddenFiles,
                                                    errorHandler: nil)!
            
            var profiles = [ProvisioningProfile]()
            for case let url as URL in enumerator {
                if let profile = self.parse(url: url) {
                    profiles.append(profile)
                }
            }
            
            DispatchQueue.main.async {
                self.loading = false
                self.profiles = profiles
            }
        }
    }
    
    private func parse(url: URL) -> ProvisioningProfile? {
        var profile: ProvisioningProfile? = nil
        do {
            let data = try Data(contentsOf: url)
            var decoder: CMSDecoder?
            CMSDecoderCreate(&decoder)
            if let decoder = decoder {
                guard CMSDecoderUpdateMessage(decoder, [UInt8](data), data.count) != errSecUnknownFormat else { return nil }
                guard CMSDecoderFinalizeMessage(decoder) != errSecUnknownFormat else { return nil }
                var newData: CFData?
                CMSDecoderCopyContent(decoder, &newData)
                if let data = newData as Data? {
                    profile = try PropertyListDecoder().decode(ProvisioningProfile.self, from: data)
                    profile?.url = url
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return profile
    }
    
    private func libraryDirectoryURL() -> URL? {
        let pw = getpwuid(getuid())
        guard let pw_dir = pw?.pointee.pw_dir,
              let realHomeDir = String(utf8String: pw_dir) else { return nil }
        return URL(fileURLWithPath: realHomeDir).appendingPathComponent("Library")
    }
    
    func delete(profile: ProvisioningProfile) {
        if let url = profile.url {
            do {
                try FileManager.default.removeItem(at: url)
                profiles.removeAll { $0 == profile }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
