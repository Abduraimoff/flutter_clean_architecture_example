import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/feature/domain/entities/person_entity.dart';
import 'package:flutter_clean_architecture/feature/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:flutter_clean_architecture/feature/presentation/bloc/person_list_cubit/person_list_state.dart';
import 'package:flutter_clean_architecture/feature/presentation/widgets/person_card_widget.dart';

class PersonList extends StatelessWidget {
  final scrollController = ScrollController();
  PersonList({Key? key}) : super(key: key);

  void setpuScrollController(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          context.read<PersonListCubit>().loadPerson();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setpuScrollController(context);
    return BlocBuilder<PersonListCubit, PersonState>(
      builder: (context, state) {
        List<PersonEntity> people = [];
        bool isLoading = false;

        if (state is PersonLoading && state.isFirstFetch) {
          return _loadingIndicator(); 
        } else if (state is PersonLoading) {
          people = state.oldPersonList;
          isLoading = true;
        } else if (state is PersonLoaded) {
          people = state.personList;
        } else if (state is PersonError) {
          return Center(
            child: Text(state.message,
                style: const TextStyle(color: Colors.white)),
          );
        }
        return ListView.separated(
          controller: scrollController,
          itemBuilder: (context, index) {
            if (index < people.length) {
              return PersonCard(person: people[index]);
            } else {
              Timer(const Duration(milliseconds: 30), () {
                scrollController
                    .jumpTo(scrollController.position.maxScrollExtent);
              });
              return _loadingIndicator();
            }
          },
          separatorBuilder: (context, index) =>
              Divider(color: Colors.grey[400]),
          itemCount: people.length + (isLoading ? 1 : 0),
        );
      },
    );
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
