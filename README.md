# Milionaire

## Описание 
  
  Игра на основе "Кто хочет стать миллионером". На главном экране есть две кнопки: "Играть" и "Рекорды". Они ведут на контроллеры игры и рекордов соответственно.
  
## Демонстрация
<img src="https://user-images.githubusercontent.com/60407631/169465585-3d2d77d6-0089-4e83-8572-7a3e2dd62a1d.png" alt="drawing" width="200"/> <img src="https://user-images.githubusercontent.com/60407631/169465598-ff7c6344-ce12-4717-a386-73ad50d9552c.png" alt="drawing" width="200"/>


## В игре реализованы патерны:

### 1. Delegate

  Передача данных с экрана игры в GameSession через делегат
  
### 2. Singleton

  Для всей игры создан синглтон Game, в котором хранится текущая сессия игры и массив рекордов 

### 3. Momento

  Все рекорды из Game.shared.results сохраняются в UserDefaults.standard
  
### 4. Strategy

### 5. Observer
