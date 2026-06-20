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
    
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(entries){ entry in
                    NavigationLink {
                        EntryDetailView(entry: entry)

                    } label: {
                        HStack{
                            if let img = imageStore.loadIMG(fileName: entry.beforeImage){
                                Image(uiImage: img)
                            }else {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width:54, height: 54)
                            }
                            VStack{
                                Text(entry.createdAt, style: .date)
                                if entry.note.isEmpty == false{
                                    Text(entry.note)
                                }
                                
                            }
                            
                            
                        }
                    }
                    
                }.onDelete(perform: delete)
            }
            .navigationTitle("Progress tracker")
            .toolbar{
                NavigationLink("Add"){
                    AddEntryView()
                }
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
