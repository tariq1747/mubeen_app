import '../dao/group_dao.dart';
import '../dao/participant_dao.dart';
import '../models/group_model.dart';
import '../models/participant_model.dart';

/// Single entry point the rest of the app uses to read/write groups and
/// participants. Combines the two DAOs and assembles [GroupModel] objects
/// (with their participants attached) so controllers never touch SQL.
class GroupRepository {
  final GroupDao _groupDao = GroupDao();
  final ParticipantDao _participantDao = ParticipantDao();

  Future<List<GroupModel>> fetchAllGroupsWithParticipants() async {
    final groupMaps = await _groupDao.fetchAllGroups();
    final groups = <GroupModel>[];
    for (final map in groupMaps) {
      final participants = await _participantsFor(map['id'] as int);
      groups.add(GroupModel.fromMap(map, participants: participants));
    }
    return groups;
  }

  Future<GroupModel?> fetchGroupDetails(int groupId) async {
    final map = await _groupDao.fetchGroupById(groupId);
    if (map == null) return null;
    final participants = await _participantsFor(groupId);
    return GroupModel.fromMap(map, participants: participants);
  }

  Future<List<ParticipantModel>> _participantsFor(int groupId) async {
    final maps = await _participantDao.fetchParticipantsByGroup(groupId);
    return maps.map((m) => ParticipantModel.fromMap(m)).toList();
  }

  /// Creates a group together with all participants added during the
  /// create-group flow, in one call.
  Future<int> createGroup(GroupModel group, List<ParticipantModel> participants) async {
    final groupId = await _groupDao.insertGroup(group);
    for (final p in participants) {
      await _participantDao.insertParticipant(p.copyWith(groupId: groupId));
    }
    return groupId;
  }

  Future<void> updateGroup(GroupModel group) => _groupDao.updateGroup(group);

  Future<void> deleteGroup(int groupId) => _groupDao.deleteGroup(groupId);

  Future<int> addParticipant(ParticipantModel participant) => _participantDao.insertParticipant(participant);

  Future<void> updateParticipant(ParticipantModel participant) => _participantDao.updateParticipant(participant);

  Future<void> deleteParticipant(int id) => _participantDao.deleteParticipant(id);

  Future<bool> isPassportUnique(int groupId, String passportNumber, {int? excludeParticipantId}) {
    return _participantDao.isPassportUniqueInGroup(groupId, passportNumber, excludeParticipantId: excludeParticipantId);
  }
}
