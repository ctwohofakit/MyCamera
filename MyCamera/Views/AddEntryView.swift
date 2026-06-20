//
//  EntryView.swift
//  MyCamera
//
//  Created by Kit Sitou on 6/18/26.
//

import SwiftUI
import UIKit
import SwiftData
import PhotosUI

struct AddEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var vm = AddEntryViewModel()
    @State private var beforeItemPicker: PhotosPickerItem? = nil
    @State private var afterItemPicker: PhotosPickerItem? = nil
    
    @State private var showBeforeCamera: Bool = false
    @State private var showAfterCamera: Bool = false
    
    private var cameraAvailable: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    @State private var isAnimated: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack{
                    Image("star")
                        .resizable()
                        .frame(width:40, height: 40)
                        .scaleEffect(isAnimated ? 1.0 : 2)
                        .onAppear{
                            withAnimation(.spring(duration: 0.6, bounce:0.8)){
                                isAnimated = true
                            }
                        }
                    Text("New Progress Entry")
                        .foregroundStyle(.pink.opacity(0.6))
                        .font(.title)
                }
                VStack {
                    Text("Before")
                    
                    photoBox(image: vm.beforeImage)
                    
                    HStack {
                        PhotosPicker("Choose photo", selection: $beforeItemPicker, matching: .images)
                        
                        Button("Take photo") {
                            showBeforeCamera = true
                        }
                        .disabled(cameraAvailable == false)
                    }
                    
                    if cameraAvailable == false {
                        Text("Camera is not available on this device")
                            .foregroundStyle(.secondary)
                    }
                }
                
                VStack {
                    Text("After")
                    
                    photoBox(image: vm.afterImage)
                    
                    HStack {
                        PhotosPicker("Choose photo", selection: $afterItemPicker, matching: .images)
                        
                        Button("Take photo") {
                            showAfterCamera = true
                        }
                        .disabled(cameraAvailable == false)
                    }
                    
                    if cameraAvailable == false {
                        Text("Camera is not available on this device")
                            .foregroundStyle(.secondary)
                    }
                }
                
                
                    TextField("Optional note", text: $vm.note)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    Button("Save") {
                        let didSave = vm.save(modelContext: modelContext)
                        if didSave {
                            dismiss()
                        }
                    }
                    .foregroundStyle(.white).bold()
                    .padding(10)
                    .padding(.horizontal, 30)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.purple.opacity(0.6))
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    )
                    //                .buttonStyle(.borderedProminent)
                    
                    
                    .bold()
                    .tint(.purple.opacity(0.5))
                    .disabled(vm.canSave() == false)
                }
                .padding()
            
        }
        .onChange(of: beforeItemPicker) { _, newValue in
            vm.setBeforePickerItem(newValue)
        }
        .onChange(of: afterItemPicker) { _, newValue in
            vm.setAfterPickerItem(newValue)
        }
        .sheet(isPresented: $showBeforeCamera) {
            CameraPicker { image in
                vm.beforeImage = image
            }
        }
        .sheet(isPresented: $showAfterCamera) {
            CameraPicker { image in
                vm.afterImage = image
            }
        }
        .alert("Error", isPresented: $vm.showError) {
            Button("OK") { }
        } message: {
            Text(vm.errorMessage)
        }
    }
    
    private func photoBox(image: UIImage?) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                .frame(height: 200)
            
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Text("Image not found")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
