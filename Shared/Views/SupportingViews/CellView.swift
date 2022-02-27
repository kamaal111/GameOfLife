//
//  CellView.swift
//  GameOfLife
//
//  Created by Kamaal M Farah on 26/02/2022.
//

import SwiftUI

struct CellView: View {
    let cell: Universe.Cell
    let size: CGSize
    let action: () -> Void

    var body: some View {
        cell.color
            .frame(width: size.width, height: size.height)
            .onTapGesture(perform: {
                action()
            })
    }
}

#if DEBUG
import ShrimpExtensions

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(cell: .alive, size: .squared(4), action: { })
    }
}
#endif
