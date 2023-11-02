
import 'package:flutter/foundation.dart';
import '../model/vote.dart';

class VoteProvider extends ChangeNotifier {
  final List<Vote> _votes = [];
  final List<VoteOption> _options = [];

  List<Vote> get votes => _votes;
  List<VoteOption> get voteoptions => _options;

  void addVote(Vote vote) {
    _votes.add(vote);
    notifyListeners();
  }

  void addVoteOptions(VoteOption voteOption) {
    _options.add(voteOption);
    notifyListeners();
  }

  void deleteVote(int index) {
    _votes.removeAt(index);
    notifyListeners();
  }

  void deleteVoteOptions(int index) {
    _votes.removeAt(index);
    notifyListeners();
  }

  void updateVote(Vote newVote, Vote oldVote, VoteOption newVoteOptions, VoteOption oldVoteOptions,) {
    final index = _votes.indexWhere((vote) => vote == oldVote);
    final index_options = _options.indexWhere((voteOption) => voteOption == oldVoteOptions);
    print('updateVote called: $index');

    if (index != -1) {
      _votes[index] = newVote;
      print('Vote updated: ${_votes[index]}');
      notifyListeners();
    } else {
      print('Vote not found in the list');
    }
    if (index_options != -1) {
      _options[index_options] = newVoteOptions;
      print('Vote updated: ${_options[index]}');
      notifyListeners();
    } else {
      print('Vote not found in the list');
    }
  }

  Vote? getVoteById(String id) {
    return _votes.firstWhere((vote) => vote.vID == id);
  }
}
