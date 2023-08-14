import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_weather/cubit.dart';

class Home extends StatelessWidget {
  const Home({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherCubit()..getData(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Weather App", style: TextStyle(color: Colors.black),),
          elevation: 0.0,
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: BlocBuilder<WeatherCubit, WeatherState>(
          buildWhen: (previous, current) => current is! GetWeatherFromPaginationLoadingState && current is! GetWeatherFromPaginationFailedState,
          builder: (context, state) {
            if (state is GetWeatherLoadingState)
            {
              return Center(child: CircularProgressIndicator(),);
            } else if (state is GetWeatherFailedState)
            {
              return Text(state.msg);
            } else if (state is GetWeatherSuccessState)
            {
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.pixels == notification.metrics.maxScrollExtent && notification is ScrollNotification)
                  {
                    BlocProvider.of<WeatherCubit>(context).getData(fromPagination: true);
                  }
                  return true;
                },
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: BlocProvider.of<WeatherCubit>(context).cityController,
                      ),
                      SizedBox(height: 15.0,),
                      MaterialButton(
                        onPressed: (){
                          BlocProvider.of<WeatherCubit>(context).getData();
                        },
                        color: Colors.lightBlueAccent,
                        minWidth: 150.0,
                        child: Text("Get Weather..", style: TextStyle(fontSize: 16.0),),
                      ),
                      SizedBox(height: 15.0,),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Name is: ${BlocProvider.of<WeatherCubit>(context).model!.name}",
                          ),
                          SizedBox(height: 16.0,),
                          Text("Temp is: ${BlocProvider.of<WeatherCubit>(context).model!.main.temp.toString()}",
                          ),
                          SizedBox(height: 16.0,),
                          Text("Min Temp is: ${BlocProvider.of<WeatherCubit>(context).model!.main.tempMin.toString()}",
                          ),
                          SizedBox(height: 16.0,),
                          Text("Max Temp is: ${BlocProvider.of<WeatherCubit>(context).model!.main.tempMax.toString()}",
                          ),
                          SizedBox(height: 16.0,),
                          Text("Pressure is: ${BlocProvider.of<WeatherCubit>(context).model!.main.pressure.toString()}",
                          ),
                          SizedBox(height: 16.0,),
                          Text("Humidity is: ${BlocProvider.of<WeatherCubit>(context).model!.main.humidity.toString()}",
                          ),
                          SizedBox(height: 16.0,),
                          Text("Feels Like is: ${BlocProvider.of<WeatherCubit>(context).model!.main.feelsLike.toString()}",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Text("Un Handled State...");
            }
          },
        ),
      ),
    );
  }
}


