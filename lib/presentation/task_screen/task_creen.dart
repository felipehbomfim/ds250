import 'package:ds250/core/app_export.dart';
import 'package:ds250/widgets/custom_elevated_button.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import '../../services/database_service.dart';
import '../../widgets/custom_text_form_field.dart';

class TaskScreen extends StatefulWidget {
  final dynamic task;
  const TaskScreen({super.key, required this.task});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController horaInicio = TextEditingController();
  TextEditingController horaFim = TextEditingController();
  String _selectedPriority = 'Alta';
  bool _obterAlerta = false;
  DateTime selectedDate = DateTime.now();
  bool disabled = false;
  String title = "Criar nova tarefa";

  void initState() {
    super.initState();
    if(widget.task.length > 0){
      nomeController.text = widget.task['task']['nome'];
      descricaoController.text = widget.task['task']['descricao'];
      _selectedPriority = widget.task['task']['prioridade'];
      horaInicio.text = widget.task['task']['hora_inicio'];
      horaFim.text = widget.task['task']['hora_fim'];
      _obterAlerta = widget.task['task']['alerta'] == "1" ? true : false;
      DateFormat format = DateFormat("yyyy-MM-dd");
      selectedDate = format.parse(widget.task['task']['data']);
      title = widget.task['task']['nome'];
    }else{
      horaInicio.text = DateFormat('HH:mm').format(DateTime.now());
      horaFim.text = DateFormat('HH:mm').format(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context, "refresh"),
        ),
        title: Text('${title}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _customBackgroundExample(),
            Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                  key: _formKey,
                  child: _buildFormBody()
              ),
            )
          ],
        ),
      ),
    );
  }

  void _setPriority(String priority) {
    setState(() {
      _selectedPriority = priority;
    });
  }

  Widget _buildFormBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Agendar", style: TextStyle(fontSize: 22.sp),),
        SizedBox(height: 10,),
        CustomTextFormField(
            controller: nomeController,
            hintText: "Nome",
            textInputType: TextInputType.emailAddress,
            filled: true,
            fillColor: Color.fromARGB(255, 26, 26, 26),
            borderDecoration: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            focusedBorderDecoration: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Color.fromARGB(255, 33, 84, 161),
                width: 1,
              ),
            ),
            textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12.sp),
            enabledBorderDecoration: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o nome';
              }
              return null;
            },
            prefixConstraints: BoxConstraints(maxHeight: 48.h),
            contentPadding: EdgeInsets.only(
                top: 12.h,
                right: 10.w,
                left: 10.w,
                bottom: 12.h
            )
        ),
        SizedBox(height: 15,),
        CustomTextFormField(
            controller: descricaoController,
            hintText: "Descrição",
            textInputType: TextInputType.emailAddress,
            filled: true,
            maxLines: 4,
            fillColor: Color.fromARGB(255, 26, 26, 26),
            borderDecoration: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            focusedBorderDecoration: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Color.fromARGB(255, 33, 84, 161),
                width: 1,
              ),
            ),
            textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12.sp),
            enabledBorderDecoration: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira a descrição';
              }
              return null;
            },
            prefixConstraints: BoxConstraints(maxHeight: 48.h),
            contentPadding: EdgeInsets.only(
                top: 12.h,
                right: 10.w,
                left: 10.w,
                bottom: 12.h
            )
        ),
        SizedBox(height: 20,),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      "Hora Início",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  CustomTextFormField(
                    onTap: () {
                      _showIOS_DatePicker(context, false);
                    },
                    readonly: true,
                    controller: horaInicio,
                    hintText: "Início",
                    textInputType: TextInputType.emailAddress,
                    filled: true,
                    textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12.sp),
                    fillColor: Color.fromARGB(255, 26, 26, 26),
                    borderDecoration: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    focusedBorderDecoration: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 33, 84, 161),
                        width: 1,
                      ),
                    ),
                    enabledBorderDecoration: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o início';
                      }
                      return null;
                    },
                    prefixConstraints: BoxConstraints(maxHeight: 48.h),
                    prefix: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.access_time_outlined,
                        color: Color.fromARGB(255, 33, 84, 161),
                      ),
                    ),
                    contentPadding: EdgeInsets.only(
                        top: 12.h,
                        right: 10.w,
                        bottom: 12.h
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      "Hora Final",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  CustomTextFormField(
                    onTap: () {
                      _showIOS_DatePicker(context, true);
                    },
                    readonly: true,
                    controller: horaFim,
                    hintText: "Fim",
                    textInputType: TextInputType.emailAddress,
                    filled: true,
                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12.sp),
                    fillColor: Color.fromARGB(255, 26, 26, 26),
                    borderDecoration: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    prefix: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.access_time_outlined,
                        color: Color.fromARGB(255, 33, 84, 161),
                      ),
                    ),
                    focusedBorderDecoration: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 33, 84, 161),
                        width: 1,
                      ),
                    ),
                    enabledBorderDecoration: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o fim';
                      }
                      return null;
                    },
                    prefixConstraints: BoxConstraints(maxHeight: 48.h),
                    contentPadding: EdgeInsets.only(
                        top: 12.h,
                        right: 10.w,
                        bottom: 12.h
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20,),
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            "Prioridade",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
            ),
          ),
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPriorityButton('Alta', Colors.red, 1),
            SizedBox(width: 5,),
            _buildPriorityButton('Média', Colors.orange, 2),
            SizedBox(width: 5,),
            _buildPriorityButton('Baixa', Colors.green, 3),
          ],
        ),
        SizedBox(height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Obter alerta?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
              ),
            ),
            FlutterSwitch(
              activeColor: Color.fromARGB(255, 33, 84, 161),
              toggleSize: 20,
              width: 60,
              height: 30,
              value: _obterAlerta,

              showOnOff: false,
              onToggle: (val) {
                setState(() {
                  _obterAlerta = val;
                });
              },
            )
          ],
        ),
        SizedBox(height: 40),
        widget.task.length == 0 ? Container(
          height: 40.h,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.white24, offset: Offset(0, 4), blurRadius: 5.0)
            ],
            gradient: !disabled ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 1.0],
              colors: [
                Color.fromARGB(255, 0, 26, 255),
                Color.fromARGB(255, 131, 162, 222)
              ],
            ) : null,
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey,
          ),
          child: CustomElevatedButton(
            text: "Criar Tarefa",
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                registrarTarefa();
              }
            },
            isDisabled: disabled,
            buttonTextStyle: TextStyle(color: Colors.white, fontSize: 14.sp),
            buttonStyle: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              shadowColor: MaterialStateProperty.all(Colors.transparent),
            ),
          )
        ) : Row(
          children: [
            Expanded(
                child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Colors.white24, offset: Offset(0, 4), blurRadius: 5.0)
                      ],
                      gradient: !disabled ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.0, 1.0],
                        colors: [
                          Color.fromARGB(255, 0, 26, 255),
                          Color.fromARGB(255, 131, 162, 222)
                        ],
                      ) : null,
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                    child: CustomElevatedButton(
                      text: "Editar Tarefa",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          atualizarTarefa();
                        }
                      },
                      isDisabled: disabled,
                      buttonTextStyle: TextStyle(color: Colors.white, fontSize: 14.sp),
                      buttonStyle: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.transparent),
                        shadowColor: MaterialStateProperty.all(Colors.transparent),
                      ),
                    )
                )
            ),
            SizedBox(width: 10,),
            Expanded(
                child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Colors.white24, offset: Offset(0, 4), blurRadius: 5.0)
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 64, 64, 64),
                    ),
                    child: CustomElevatedButton(
                      text: "Deletar Tarefa",
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog(
                              icon: 'info',
                              title: 'Atenção!',
                              cancelButtonText: "Cancelar",
                              confirmButtonText: "Sim, continuar",
                              message: "Tem certeza que deseja excluir a tarefa?",
                              onOkPressed: () async {
                                removerTarefa();
                                Navigator.of(context).pop(); // Fecha o dialog
                              },
                              onCancelPressed: () {
                                Navigator.of(context).pop(); // Fecha o dialog
                              },
                            );
                          },
                        );
                      },
                      isDisabled: disabled,
                      buttonTextStyle: TextStyle(color: Colors.white, fontSize: 14.sp),
                      buttonStyle: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.transparent),
                        shadowColor: MaterialStateProperty.all(Colors.transparent),
                      ),
                    )
                )
            ),
          ],
        )
      ],
    );
  }

  Future<void> removerTarefa() async {
    try{
      setState(() {
        disabled = true;
      });
      await DatabaseHelper.instance.deleteTask(widget.task['task']['id']);
      toastification.show(
        style: ToastificationStyle.fillColored,
        type: ToastificationType.success,
        context: context,
        showProgressBar: true,
        autoCloseDuration: Duration(seconds: 4),
        title: Text('Sucesso!'),
        description: RichText(text: const TextSpan(text: 'A tarefa foi removida com sucesso!')),
        callbacks: ToastificationCallbacks(
          onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
          onCloseButtonTap: (toastItem) {
            Navigator.pop(context, "refresh");
          },
          onAutoCompleteCompleted: (toastItem) {
            Navigator.pop(context, "refresh");
          },
          onDismissed: (toastItem) {
            Navigator.pop(context, "refresh");
          },
        ),
      );
    }catch(e){
      setState(() {
        disabled = false;
      });
      print(e);
      toastification.show(
        backgroundColor: Colors.red,
        style: ToastificationStyle.fillColored,
        type: ToastificationType.error,
        context: context,
        showProgressBar: false,
        title: Text('Oops!'),
        description: RichText(text: const TextSpan(text: 'Ocorreu um erro ao remover a tarefa.')),
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }

  Future<void> atualizarTarefa() async {
    try{
      setState(() {
        disabled = true;
      });
      Map<String, dynamic> inputData = {
        'nome': nomeController.text,
        'descricao': descricaoController.text,
        'hora_inicio': horaInicio.text,
        'hora_fim': horaFim.text,
        'prioridade': _selectedPriority,
        'alerta': _obterAlerta,
        'concluido': false,
        'data': selectedDate.toString()
      };
      await DatabaseHelper.instance.updateTask(widget.task['task']['id'], inputData);
      toastification.show(
        style: ToastificationStyle.fillColored,
        type: ToastificationType.success,
        context: context,
        showProgressBar: true,
        autoCloseDuration: Duration(seconds: 4),
        title: Text('Sucesso!'),
        description: RichText(text: const TextSpan(text: 'A tarefa foi atualizada com sucesso!')),
        callbacks: ToastificationCallbacks(
          onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
          onCloseButtonTap: (toastItem) {
            Navigator.pop(context, "refresh");
          },
          onAutoCompleteCompleted: (toastItem) {
            Navigator.pop(context, "refresh");
          },
          onDismissed: (toastItem) {
            Navigator.pop(context, "refresh");
          },
        ),
      );
    }catch(e){
      setState(() {
        disabled = false;
      });
      print(e);
      toastification.show(
        backgroundColor: Colors.red,
        style: ToastificationStyle.fillColored,
        type: ToastificationType.error,
        context: context,
        showProgressBar: false,
        title: Text('Oops!'),
        description: RichText(text: const TextSpan(text: 'Ocorreu um erro ao atualizar a tarefa.')),
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }

  Future<void> registrarTarefa() async {
    try{
      setState(() {
        disabled = true;
      });
      Map<String, dynamic> inputData = {
        'nome': nomeController.text,
        'descricao': descricaoController.text,
        'hora_inicio': horaInicio.text,
        'hora_fim': horaFim.text,
        'prioridade': _selectedPriority,
        'alerta': _obterAlerta,
        'concluido': false,
        'data': selectedDate.toString()
      };
      await DatabaseHelper.instance.registerTask(inputData);
      toastification.show(
        style: ToastificationStyle.fillColored,
        type: ToastificationType.success,
        context: context,
        showProgressBar: true,
        autoCloseDuration: Duration(seconds: 4),
        title: Text('Sucesso!'),
        description: RichText(text: const TextSpan(text: 'A tarefa foi registrada com sucesso!')),
        callbacks: ToastificationCallbacks(
          onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
          onCloseButtonTap: (toastItem) {
            Navigator.pop(context, "refresh");
          },
          onAutoCompleteCompleted: (toastItem) {
            Navigator.pop(context, "refresh");
          },
          onDismissed: (toastItem) {
            Navigator.pop(context, "refresh");
          },
        ),
      );
    }catch(e){
      setState(() {
        disabled = false;
      });
      print(e);
      toastification.show(
        backgroundColor: Colors.red,
        style: ToastificationStyle.fillColored,
        type: ToastificationType.error,
        context: context,
        showProgressBar: false,
        title: Text('Oops!'),
        description: RichText(text: const TextSpan(text: 'Ocorreu um erro ao salvar a tarefa.')),
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }

  Widget _buildPriorityButton(String priority, Color color, int value) {
    bool isSelected = _selectedPriority == priority;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _setPriority(priority),
        child: Ink(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: color,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              priority,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showIOS_DatePicker(ctx, fim) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
          height: 230,
          color: Color.fromARGB(255, 26, 26, 26),
          child: Column(
            children: [
              Container(
                color: Color.fromARGB(255, 49, 49, 51),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 40,),
                    Material(
                      color: Colors.transparent,
                      child: Text('Escolha uma data', style: TextStyle(color: Colors.white),),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text('FECHAR', style: TextStyle(color: Colors.blue),),
                    )
                  ],
                ),
              ),
              Container(
                height: 180,
                child: CupertinoDatePicker(
                  use24hFormat: true,
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (DateTime newDateTime) {
                    if(fim){
                      horaFim.text = DateFormat('HH:mm').format(newDateTime);
                    }else{
                      horaInicio.text = DateFormat('HH:mm').format(newDateTime);
                    }
                  },
                ),
              ),
            ],
          ),
        )
    );
  }

  List<DateTime> getDisabledDates() {
    List<DateTime> disabledDates = [];
    DateTime today = DateTime.now();
    DateTime start = DateTime(2020); // Supondo que você queira desabilitar datas desde 2020 até a data atual

    for (DateTime d = start; d.isBefore(DateTime(today.year, today.month, today.day)); d = d.add(Duration(days: 1))) {
      disabledDates.add(d);
    }

    return disabledDates;
  }

  EasyDateTimeLine _customBackgroundExample() {
    return EasyDateTimeLine(
      locale: "pt-BR",
      initialDate: selectedDate,
      onDateChange: (date) {
        setState(() {
          selectedDate = date;
        });
      },
      disabledDates: getDisabledDates(),
      headerProps: const EasyHeaderProps(
        selectedDateStyle: TextStyle(color: Color.fromARGB(255, 33, 84, 161)),
        monthStyle: TextStyle(color: Color.fromARGB(255, 33, 84, 161)),
        monthPickerType: MonthPickerType.switcher,
        dateFormatter: DateFormatter.fullDateDMY(),
      ),
      timeLineProps: EasyTimeLineProps(
        margin: EdgeInsets.zero,
      ),
      dayProps: EasyDayProps(
        height: 60.0,
        width: 50,
        dayStructure: DayStructure.dayStrDayNum,
        disabledDayStyle: DayStyle(
          dayNumStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          dayStrStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.7),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        inactiveDayStyle: DayStyle(
          dayNumStyle: TextStyle(color: Color.fromARGB(255, 149, 149, 150), fontWeight: FontWeight.bold),
          dayStrStyle: TextStyle(color: Color.fromARGB(255, 149, 149, 150), fontWeight: FontWeight.bold),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        todayStyle: DayStyle(
          dayNumStyle: TextStyle(color: Color.fromARGB(255, 149, 149, 150), fontWeight: FontWeight.bold),
          dayStrStyle: TextStyle(color: Color.fromARGB(255, 149, 149, 150), fontWeight: FontWeight.bold),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        activeDayStyle: DayStyle(
          dayNumStyle: TextStyle(color: Color.fromARGB(255, 33, 84, 161), fontWeight: FontWeight.bold),
          dayStrStyle: TextStyle(color: Color.fromARGB(255, 33, 84, 161), fontWeight: FontWeight.bold),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 33, 84, 161),
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
    );
  }
}