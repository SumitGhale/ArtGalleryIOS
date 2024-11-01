

import Foundation

class ArtGalleryFileManager{
    let fileManager = FileManager.default
    
    //  get document directory
    func getDocumentdirectory() -> URL?{
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else{
            print("Error getting document url")
            return nil
        }
        return documentURL
    }
}
