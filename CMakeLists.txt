cmake_minimum_required(VERSION 3.16)

project(freezer VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appfreezer
    main.cpp
    readsensor.h readsensor.cpp
    processitem.h processitem.cpp
    processmodel.h processmodel.cpp
    product.h product.cpp
    productsmodel.h productsmodel.cpp
    dbapi.h dbapi.cpp
)

qt_add_qml_module(appfreezer
    URI freezer
    VERSION 1.0
    RESOURCES
        img/logo.png
        img/gear.svg
        img/trash.svg
        img/edit.svg
        img/scale.svg
        img/temperature.svg
        img/clock.svg
        img/stack.svg
    QML_FILES
        Main.qml
        SetpointField.qml
        ProcessItemDelegate.qml
        RadialBarShape.qml
        StatusCard.qml
        SettingsPanel.qml
        PopUpStop.qml
        PopUpStart.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appfreezer PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appfreezer
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appfreezer
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appfreezer
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
