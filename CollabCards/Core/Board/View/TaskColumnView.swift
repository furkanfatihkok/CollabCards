//
//  TaskColumnView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI

struct TaskColumnView: View {
    var title: String
    var tasks: [Task]
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            List(tasks) { task in
                Text(task.title)
            }
        }
    }
}

#Preview {
    TaskColumnView(title: "Sanane", tasks: [])
}
