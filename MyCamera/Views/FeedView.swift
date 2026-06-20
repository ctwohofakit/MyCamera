//
//  DetailView.swift
//  MyCamera
//
//  Created by Kit Sitou on 6/18/26.
//

import SwiftUI
import SwiftData

struct FeedView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort:\ProgressEntryModel.createdAt, order: .reverse)
    
    private var entries:[ProgressEntryModel] = []
    private var imageStore = ImageStoreService()
    @State private var isAnimated = false
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(entries){ entry in
                    NavigationLink {
                        EntryDetailView(entry: entry)

                    } label: {
                        HStack{
                            if let img = imageStore.loadIMG(fileName: entry.beforeImage){
                                ZStack{
                                    Image("frame")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width:110, height: 110)
                                    
                                    Image(uiImage: img)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width:70, height: 70)
//                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .padding(10)
                                    
                       
                                }
                                    
                            }else {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width:100, height: 100)
                            }
                            VStack{
                                HStack{
                                    Image("greet")
                                        .resizable()
                                        .frame(width:20, height: 20)
                                        .scaleEffect(isAnimated ? 1.0 : 1.8)
                                        .onAppear{
                                            withAnimation(.spring(duration: 0.8, bounce:0.3)){
                                                isAnimated = true
                                            }
                                        }
                                    
                                    Text(" - \(entry.createdAt, style: .date)")
                                        .foregroundStyle(.gray)
                                    //                                    .background(.gray, in: Capsule())
                                    
                                    if entry.note.isEmpty == false{
                                        Text(entry.note)
                                    }
                                }
                                .padding()

                            }
                            Spacer()
                            
                        }
                    }
                    
                }.onDelete(perform: delete)
            }
            .navigationTitle("Progress tracker")
            .toolbar{
//                NavigationLink("Add"){
//                    AddEntryView()
//                }
                NavigationLink(value: "addRoute") {
                              Image(systemName: "camera.fill")
                        .foregroundStyle(.pink.opacity(0.6))
                                  .imageScale(.large)
                          }
            }
            .navigationDestination(for: String.self) { value in
                    if value == "addRoute" {
                        AddEntryView()                    }
                }
        }
    }
    
    func delete(_ indexSet: IndexSet) {
        for index in indexSet{
            let entry = entries[index]
          imageStore.deleteIMG(fileName: entry.beforeImage)
        imageStore.deleteIMG(fileName: entry.afterImage)
            
            modelContext.delete(entry)
        }
        try? modelContext.save()
    }
    
}


#Preview {

        FeedView().modelContainer(for: ProgressEntryModel.self, inMemory: true)
}
