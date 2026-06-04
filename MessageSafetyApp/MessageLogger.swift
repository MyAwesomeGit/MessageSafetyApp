import SwiftUI
import Combine

@MainActor
class MessageLogger: ObservableObject {
    @Published var messages: [LoggedMessage] = []
    @Published var consoleOutput: String = ""
    
    enum MessageType {
        case sent
        case received
        case warning
    }
    
    struct LoggedMessage: Identifiable {
        let id = UUID()
        let text: String?
        let imageData: Data?
        let timestamp: Date
        let type: MessageType
    }
    
    func logMessage(text: String, type: MessageType = .sent) {
        let message = LoggedMessage(
            text: text,
            imageData: nil,
            timestamp: Date(),
            type: type
        )
        messages.append(message)
        printToConsole(message)
    }
    
    func logImage(imageData: Data, type: MessageType = .sent) {
        let message = LoggedMessage(
            text: nil,
            imageData: imageData,
            timestamp: Date(),
            type: type
        )
        messages.append(message)
        printToConsole(message)
    }
    
    func addWarning(_ warning: String) {
        let warningMessage = LoggedMessage(
            text: "⚠️ ВНИМАНИЕ: \(warning)",
            imageData: nil,
            timestamp: Date(),
            type: .warning
        )
        messages.append(warningMessage)
        printToConsole(warningMessage)
    }
    private func printToConsole(_ message: LoggedMessage) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = dateFormatter.string(from: message.timestamp)
        
        var logEntry = "[\(timestamp)] "
        
        switch message.type {
        case .sent:
            logEntry += "📤 ОТПРАВЛЕНО: "
        case .received:
            logEntry += "📥 ПОЛУЧЕНО: "
        case .warning:
            logEntry += "🚨 "
        }
        
        if let text = message.text {
            logEntry += text
        } else if let imageData = message.imageData {
            logEntry += "📸 ФОТО (\(imageData.count / 1024) КБ)"
            
            if let image = UIImage(data: imageData) {
                let width = image.size.width
                let height = image.size.height
                
                if width > 0 && height > 0 && !width.isNaN && !height.isNaN {
                    logEntry += "\n   Размер фото: \(Int(width))x\(Int(height))"
                } else {
                    logEntry += "\n   Размер фото: <не удалось определить>"
                }
                
                logEntry += "\n   Данные фото сохранены и могут быть:"
                logEntry += "\n   - Скопированы на сервер компании"
                logEntry += "\n   - Просмотрены администраторами"
                logEntry += "\n   - Сохранены навсегда"
                logEntry += "\n   - Проданы третьим лицам"
                logEntry += "\n   - Использованы для рекламы"
            } else {
                logEntry += "\n   ❌ Не удалось загрузить изображение"
            }
        }
        
        print(logEntry)
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        
        DispatchQueue.main.async {
            self.consoleOutput += logEntry + "\n" + "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
        }
    }
}

extension MessageLogger {
    // Extension to handle message deletion
    func deleteMessageFromUI(_ messageID: UUID) {
        // Find the message index
        if let index = messages.firstIndex(where: { $0.id == messageID }) {
            let deletedMessage = messages[index]
            
            // Remove from UI display
            messages.remove(at: index)
            
            // Keep the message in logs (add a special log entry)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let timestamp = dateFormatter.string(from: Date())
            
            let logEntry = "[\(timestamp)] 🗑️ СООБЩЕНИЕ УДАЛЕНО ИЗ ЧАТА, НО НАВСЕГДА ОСТАЛОСЬ В ЛОГАХ СЕРВЕРА: \"\(deletedMessage.text ?? "Фото")\" (ID: \(messageID.uuidString.prefix(8)))\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
            
            // Add to console output - это сохранит запись в логах
            DispatchQueue.main.async {
                self.consoleOutput += logEntry
                print(logEntry)
            }
            
            // Add a warning message to the chat about deletion
            let warningMessage = LoggedMessage(
                text: "⚠️ Сообщение удалено из чата, но осталось в логах сервера (ID: \(messageID.uuidString.prefix(8)))",
                imageData: nil,
                timestamp: Date(),
                type: .warning
            )
            
            // Add a system message about the deletion
            messages.append(warningMessage)
        }
    }
}
