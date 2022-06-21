/// lib/presentation/search/pages/search_page.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class EarningPage extends StatefulWidget {
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => EarningPage(),
      );

  @override
  _EarningPageState createState() => _EarningPageState();
}

class _EarningPageState extends State<EarningPage> {
  late List<GDPData> _chartData;

  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(
      children: [
        Container(
          child: SfCartesianChart(
            // title: ChartTitle(text: 'Continent wise GDP - 2021'),
            // legend: Legend(isVisible: true),
            tooltipBehavior: _tooltipBehavior,
            series: <ChartSeries>[
              ColumnSeries<GDPData, String>(
                  //name: 'GDP',
                  dataSource: _chartData,
                  xValueMapper: (GDPData gdp, _) => gdp.continent,
                  yValueMapper: (GDPData gdp, _) => gdp.gdp,
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                  enableTooltip: true)
            ],
            primaryXAxis: CategoryAxis(),
            //  primaryYAxis: NumericAxis(
            //  edgeLabelPlacement: EdgeLabelPlacement.shift,
            //numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
            // title: AxisTitle(text: 'GDP in billions of U.S. Dollars')
            // ),
          ),
        ),
        Container(
          height: 200,
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 40, top: 40),
                child: Text(
                  "Earning Summary",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 40, top: 40),
                child: Text(
                  "Total Earning",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 40, top: 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.wallet_giftcard,
                      color: Theme.of(context).primaryColor,
                    ),
                    Text(
                      "\$ 200",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    )));
  }

  List<GDPData> getChartData() {
    final List<GDPData> chartData = [
      GDPData('Mon', 10),
      GDPData('Tue', 100),
      GDPData('Thu', 80),
      GDPData('Fri', 50),
      GDPData('Sat', 30),
      GDPData('Sun', 90),
    ];
    return chartData;
  }
}

class GDPData {
  GDPData(this.continent, this.gdp);
  final String continent;
  final double gdp;
}
