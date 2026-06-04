import SwiftUI
import PhotosUI
import Combine

struct MessageSafetyView: View {
    @StateObject private var logger = MessageLogger()
    @State private var messageText = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var showConsole = false
    @State private var showWarning = false
    
    var body: some View {
        NavigationView {
            VStack {
                warningHeader
                
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(logger.messages) { message in
                                MessageBubbleView(message: message, logger: logger)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: logger.messages.count) { _ in
                        if let lastMessage = logger.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id)
                            }
                        }
                    }
                }
                
                inputArea
            }
            .navigationTitle("Чат с другом")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showConsole.toggle()
                    } label: {
                        Image(systemName: "terminal.fill")
                    }
                }
            }
            .sheet(isPresented: $showConsole) {
                ConsoleView(logger: logger)
            }
        }
    }
    
    private var warningHeader: some View {
        VStack(spacing: 4) {
            HStack {
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.8))
        }
    }
    
    private var inputArea: some View {
        HStack(spacing: 12) {
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                Image(systemName: "photo.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .onChange(of: selectedPhoto) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                        // Сразу отправляем фото без предупреждения
                        sendMessage()
                    }
                }
            }
            
            TextField("Введите сообщение...", text: $messageText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button {
                if !messageText.isEmpty {
                    showWarning = true
                    sendMessage()
                }
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
    
    private func sendMessage() {
        if !messageText.isEmpty {
            logger.logMessage(text: messageText, type: .sent)
            messageText = ""
            
            let randomAdmins = Int.random(in: 12...47)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                logger.addWarning("СЕРВЕР: Сообщение сохранено в базе данных. Доступ имеют \(randomAdmins) посторонних.")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                logger.logMessage(text: "Приветики! Я получил твое сообщение. 👀", type: .received)
            }
        }
        
        if let imageData = selectedImageData {
            logger.logImage(imageData: imageData, type: .sent)
            selectedImageData = nil
            selectedPhoto = nil
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                logger.addWarning("СЕРВЕР: Фото сохранено. Метаданные извлечены. Геолокация: Екатеринбург")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                logger.addWarning("СЕРВЕР: Фото добавлено в рекламную базу.")
            }
        }
    }
}
