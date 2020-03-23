# MVVMC
This is another iOS MVVMC experiment.

In this MVVMC, Coordinators manage sub-flows from them, so create only things(VC/VM/Coordinator) of children and do not have a function like start().

AppCoordinator has setup function, you can think it is start function.

A view controller has a reference to a view model.
The view model has a reference to a coordinator.
The coordinator has an unowned refers to the view controller.

Three view controllers/view models/coordinators have slightly different implementations.
You can check it.

## Author

skyofdwarf, skyofdwarf@gmail.com

## License

RxReduxift is available under the MIT license. See the LICENSE file for more info.
