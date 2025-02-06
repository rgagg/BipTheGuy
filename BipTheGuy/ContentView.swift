//
//  ContentView.swift
//  BipTheGuy
//
//  Created by Richard Gagg on 6/2/2025.
//

import SwiftUI
import AVFAudio
import PhotosUI

struct ContentView: View {
  
  @State private var selectedPhoto: PhotosPickerItem?
  @State private var soundName: String = "punchSound"
  @State private var audioPlayer: AVAudioPlayer!
  @State private var animateImage: Bool = true
  @State private var bipImage: Image = Image("clown")
  
  var body: some View {
    Spacer()
    
    //Bip Image
    bipImage
      .resizable()
      .scaledToFit()
      .scaleEffect(animateImage ? 1 : 0.9)
      .onTapGesture {
        playSound()
        animateImage = false
        withAnimation(.spring(response: 0.3, dampingFraction: 0.2)) {
          animateImage = true
        }
      }
      .padding(15)
    
    Spacer()
    
    //MARK: Photos Library Picker
    PhotosPicker(
      selection: $selectedPhoto,
      matching: .images,
      preferredItemEncoding: .automatic) {
        Label("Photo Library", systemImage: "photo.on.rectangle.angled")
      }
      .onChange(of: selectedPhoto) {
        getImageFromLibrary(From: selectedPhoto)
      }
  }
  
  //MARK: Get Image From Library
  func getImageFromLibrary(From photosPickerItem: PhotosPickerItem?) {
    /*
     To display photo image as an image, we need to:
     - get the data onside the PhotosPikerItem selectedPhoto
     - use the data to create a UIImage
     - use the UIImage to create the image
     - assign the image to bipImage
     */

    Task {
      if let newImage = try? await photosPickerItem?.loadTransferable(type: Image.self) {
        bipImage = newImage
      } else {
        print("🤬 Could not load image.")
      }
    }
  }
  
  //MARK: Play Sound
  func playSound() {
    
    guard let soundFile = NSDataAsset(name: soundName) else
    {
      print("🤬 Could not read file named \(soundName).")
      return
    }
    
    do {
      audioPlayer = try AVAudioPlayer(data: soundFile.data)
      audioPlayer.play()
    } catch {
      print("🤬 ERROR: \(error.localizedDescription) creating audioPlayer")
    }
  }
  
}

#Preview {
  ContentView()
}
