import SwiftUI

struct MessageBubbleView: View {
    let message: MessageLogger.LoggedMessage
    @ObservedObject var logger: MessageLogger
    @State private var offset: CGSize = .zero
    @State private var isDeleting = false
    
    var body: some View {
        HStack {
            if message.type == .sent {
                Spacer(minLength: 60)
            }
            
            VStack(alignment: message.type == .sent ? .trailing : .leading, spacing: 4) {
                if let text = message.text {
                    Text(text)
                        .padding(12)
                        .background(backgroundColor)
                        .foregroundColor(textColor)
                        .cornerRadius(16)
                }
                
                if let imageData = message.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .cornerRadius(12)
                        .overlay(
                            Image(systemName: "eye.fill")
                                .foregroundColor(.red)
                                .font(.title)
                                .padding(8)
                                .background(Color.black.opacity(0.6))
                                .cornerRadius(8)
                                .padding(8),
                            alignment: .topTrailing
                        )
                }
                
                if message.type != .warning {
                    HStack(spacing: 4) {
                        Image(systemName: "server.rack")
                            .font(.system(size: 8))
                        Text("Сохранено на сервере")
                            .font(.system(size: 8))
                    }
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
                }
            }
            .offset(x: offset.width)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.width < 0 {
                            offset = gesture.translation
                        }
                    }
                    .onEnded { gesture in
                        if gesture.translation.width < -100 {
                            withAnimation {
                                offset = CGSize(width: -UIScreen.main.bounds.width, height: 0)
                                isDeleting = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                logger.deleteMessageFromUI(message.id)
                            }
                        } else {
                            withAnimation {
                                offset = .zero
                            }
                        }
                    }
            )
            .animation(.spring(), value: offset)
            
            if message.type != .sent {
                Spacer(minLength: 60)
            }
        }
        .opacity(isDeleting ? 0 : 1)
    }
    
    private var backgroundColor: Color {
        switch message.type {
        case .sent:
            return .blue
        case .received:
            return .gray.opacity(0.3)
        case .warning:
            return .red.opacity(0.2)
        }
    }
    
    private var textColor: Color {
        message.type == .sent ? .white : .primary
    }
}
