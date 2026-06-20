//
//  AddEntryView.swift
//  MyCamera
//
//  Created by Kit Sitou on 6/18/26.
//
import SwiftUI

struct EntryDetailView: View {
    let entry: ProgressEntryModel
    
    private var imageStore = ImageStoreService()
    
    var body: some View {
        Text("Add Entry")
        ScrollView{
            VStack(spacing:12){
                Text(entry.createdAt, format: .dateTime)
                    .font(.title2)
                    .bold()
                
                VStack(alignment: .leading){
                    Text("Before:")
                    photoBox(fileName: entry.beforeImage)
                    
                    Text("After:")
                    photoBox(fileName: entry.afterIamge)
                }
                if entry.note.isEmpty == false{
                    VStack{
                        Text("Note")
                        Text(entry.note)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("EntryDetailView")
        .navigationBarTitleDisplayMode(.inline)
        
        
        
    }
    
    //computed component
    private func photoBox(fileName:String) -> some View {
        ZStack{
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                .frame(height: 260)
            
            if let img = imageStore.loadIMG(fileName: fileName){
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(height:260)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else{
                Text("Image not found")
                    .foregroundStyle(.secondary)
            }
                
        }
    }
    
    
    
    
    
}


