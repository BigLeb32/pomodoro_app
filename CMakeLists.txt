cmake_minimum_required(VERSION 3.14)

project(pomodoro_app VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick)
    
set(PROJECT_SOURCES
        main.cpp
        resources.qrc
)

qt_add_executable(pomodoro_app
    ${PROJECT_SOURCES})

target_link_libraries(pomodoro_app
  PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick)


include(GNUInstallDirs)
install(TARGETS pomodoro_app
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

if(QT_VERSION_MAJOR EQUAL 6)
    qt_import_qml_plugins(pomodoro_app)
    qt_finalize_executable(pomodoro_app)
endif()
