// dafny 4.10.1.0
// Command Line Options:
// Kermit2PC

function time_speed(): nat
{
  var this_0 := 3;

  this_0
}

function time_uncertainty(): nat
{
  var this_1 := 3;

  this_1
}

function INVALID_TIME(): tTime
{
  var this_2 := 0 - 1;

  this_2
}

function INVALID_VALUE(): tVal
{
  var this_3 := 0 - 1;

  this_3
}

function key_shard(key: tKey, numShards: nat): nat
{
  var this_4 := key % numShards;

  this_4
}

function max_time(t1: tTime, t2: tTime): tTime
{
  var this_7 := if t1 <= t2 then
                  var this_5 := t1;
                  this_5 else
                  var this_6 := t2;
                  this_6;

  this_7
}

function value_of_key_at_time(versions: map<tKey, map<tTime, tVal>>, key: tKey, time: tTime): tVal
{
  var this_8 := INVALID_VALUE();

  this_8
}

function time_of_last_update(versions: map<tKey, map<tTime, tVal>>, key: tKey): tTime
{
  var this_9 := INVALID_TIME();

  this_9
}

datatype MachineID = Clock(clock: ClockID) | Router(router: RouterID) | Shard(shard: ShardID)

datatype Event = Null(Null: ()) | halt(Null: ()) | eClockTick(Null: ()) | eClockTimeReq(TClockTimeReq: tClockTimeReq) | eClockTimeRsp(TClockTimeRsp: tClockTimeRsp) | eClockAlarmReq(TClockAlarmReq: tClockAlarmReq) | eClockAlarmRsp(TClockAlarmRsp: tClockAlarmRsp) | eDisconnectRouter(TDisconnectRouter: tDisconnectRouter) | eDisconnectRouterAck(TDisconnectRouterAck: tDisconnectRouterAck) | eMonitorInit(TMonitorInit: tMonitorInit) | eMonitorRouterTxnStatus(TMonitorRouterTxnStatus: tMonitorRouterTxnStatus) | eStartReq(TStartReq: tStartReq) | eStartRsp(TStartRsp: tStartRsp) | eReadReq(TReadReq: tReadReq) | eReadRsp(TReadRsp: tReadRsp) | eUpdateReq(TUpdateReq: tUpdateReq) | eUpdateRsp(TUpdateRsp: tUpdateRsp) | eCommitReq(TCommitReq: tCommitReq) | eCommitRsp(TCommitRsp: tCommitRsp) | eRollbackReq(TRollbackReq: tRollbackReq) | eTriggerReadRsp(Null: ()) | eTriggerUpdateRsp(Null: ()) | eShardReadReq(TShardReadReq: tShardReadReq) | eShardReadRsp(TShardReadRsp: tShardReadRsp) | eShardUpdateReq(TShardUpdateReq: tShardUpdateReq) | eShardUpdateRsp(TShardUpdateRsp: tShardUpdateRsp) | eShardPrepareReq(TShardPrepareReq: tShardPrepareReq) | eShardPrepareRsp(TShardPrepareRsp: tShardPrepareRsp) | eShardCommit(TShardCommit: tShardCommit) | eShardAbort(TShardAbort: tShardAbort) | eShardCommitReq(TShardCommitReq: tShardCommitReq) | eShardCommitRsp(TShardCommitRsp: tShardCommitRsp) | eShardInquireReq(TShardInquireReq: tShardInquireReq) | eShardInquireRsp(TShardInquireRsp: tShardInquireRsp)

datatype Message = New(target: MachineID, event: Event)

datatype Machine = Clock(clock: Clock) | Router(router: Router) | Shard(shard: Shard)

newtype tTime = nat

datatype tClockTime = New(earliest: tTime, latest: tTime)

datatype tClockTimeReq = New(requester: MachineID, requestId: nat)

datatype tClockTimeRsp = New(requestId: nat, now: tClockTime)

datatype tClockAlarmReq = New(requester: MachineID, requestId: nat, wait_time: tTime)

datatype tClockAlarmRsp = New(requestId: nat)

datatype tDisconnectRouter = New(sender: MachineID)

datatype tDisconnectRouterAck = New(router: MachineID)

datatype tMonitorInit = New(numClients: nat, numRouters: nat, numShards: nat)

datatype tMonitorRouterTxnStatus = New(tid: tTid, participants: set<MachineID>, status: tTxnStatus, commit_time: tTime)

type tTid = nat

type tKey = nat

type tVal = nat

datatype tStartReq = New(client: MachineID)

datatype tStartRsp = New(router: MachineID, tid: tTid, start_time: tTime)

datatype tReadReq = New(tid: tTid, key: tKey)

datatype tReadRsp = New(router: MachineID, tid: tTid, key: tKey, val: tVal, status: tReqStatus)

datatype tUpdateReq = New(tid: tTid, key: tKey, val: tVal)

datatype tUpdateRsp = New(router: MachineID, tid: tTid, key: tKey, val: tVal, status: tReqStatus)

datatype tCommitReq = New(tid: tTid)

datatype tCommitRsp = New(tid: tTid, status: tTxnStatus)

datatype tRollbackReq = New(tid: tTid)

datatype tShardReadReq = New(router: MachineID, tid: tTid, key: tKey, start_time: tTime)

datatype tShardReadRsp = New(shard: MachineID, tid: tTid, key: tKey, val: tVal, status: tReqStatus)

datatype tShardUpdateReq = New(router: MachineID, tid: tTid, key: tKey, val: tVal, start_time: tTime)

datatype tShardUpdateRsp = New(shard: MachineID, tid: tTid, key: tKey, val: tVal, status: tReqStatus)

datatype tShardPrepareReq = New(router: MachineID, tid: tTid, lead_participant: MachineID)

datatype tShardPrepareRsp = New(shard: MachineID, tid: tTid, status: tShardPrepareStatus, prepare_time: tTime)

datatype tShardCommit = New(tid: tTid, commit_time: tTime)

datatype tShardAbort = New(tid: tTid)

datatype tShardCommitReq = New(router: MachineID, tid: tTid, max_prepare_time: tTime, participants: set<MachineID>)

datatype tShardCommitRsp = New(shard: MachineID, tid: tTid, status: tTxnStatus, commit_time: tTime)

datatype tShardInquireReq = New(shard: MachineID, tid: tTid, read: tShardReadReq)

datatype tShardInquireRsp = New(tid: tTid, status: tTxnStatus, commit_time: tTime, read: tShardReadReq)

datatype tTxnStatus = ERROR | ACTIVE | COMMITTED | ABORTED

datatype tReqStatus = UNKNOWN | OK | ABORT

datatype tShardPrepareStatus = SHARD_OK | SHARD_ABORT

newtype ClockID = nat

datatype ClockState = EventLoop(entry: bool)

datatype Clock = New(globaltime: nat, localtime: map<MachineID, tClockTime>, pending: set<tClockAlarmReq>, state: ClockState)

newtype RouterID = nat

datatype RouterState = Init(entry: bool) | WaitForEvents(entry: bool) | Disconnected(entry: bool)

datatype Router = New(routerId: nat, localClock: MachineID, shards: map<nat, MachineID>, client: map<tTid, MachineID>, start_time: map<tTid, tTime>, participants: map<tTid, set<MachineID>>, lead_participant: map<tTid, MachineID>, committed: set<tTid>, prepare_responses: map<tTid, set<tShardPrepareRsp>>, prepare_commit_decision: map<tTid, bool>, prepare_commit_time: map<tTid, tTime>, state: RouterState)

newtype ShardID = nat

datatype ShardState = Init(entry: bool) | WaitForRequests(entry: bool)

datatype Shard = New(shardId: nat, localClock: MachineID, clock: tTime, versions: map<tKey, map<tTime, tVal>>, write_buff: map<tTid, map<tKey, tVal>>, router: map<tTid, MachineID>, lead_shard: map<tTid, MachineID>, prepared: map<tTid, tTime>, committed: map<tTid, tTime>, aborted: set<tTid>, pending_reads: map<tShardReadReq, set<tTid>>, pending_updates: set<tShardUpdateReq>, locked_keys: set<tKey>, state: ShardState)

datatype System = New(machines: map<MachineID, Machine>, network: Network) {
  function deliver_eClockTick_to_Clock_in_EventLoop(src: MachineID, dst: MachineID): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eClockTick?
    requires machines[dst].Clock?
    requires machines[dst].clock.state.EventLoop?
  {
    var (event, network') := network.receive(src, dst);

    var this_0 := this.(network := network');

    this_0
  }

  function deliver_eClockTimeReq_to_Clock_in_EventLoop(src: MachineID, dst: MachineID, payload: tClockTimeReq): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eClockTimeReq?
    requires network.receive(src, dst).0.TClockTimeReq == payload
    requires machines[dst].Clock?
    requires machines[dst].clock.state.EventLoop?
  {
    var (event, network') := network.receive(src, dst);

    var this_0 := this.(network := network');

    this_0
  }

  function deliver_eClockAlarmReq_to_Clock_in_EventLoop(src: MachineID, dst: MachineID, payload: tClockAlarmReq): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eClockAlarmReq?
    requires network.receive(src, dst).0.TClockAlarmReq == payload
    requires machines[dst].Clock?
    requires machines[dst].clock.state.EventLoop?
  {
    var (event, network') := network.receive(src, dst);

    var this_0 := this.(network := network');

    this_0
  }

  function deliver_eStartReq_to_Router_in_WaitForEvents(src: MachineID, dst: MachineID, payload: tStartReq): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eStartReq?
    requires network.receive(src, dst).0.TStartReq == payload
    requires machines[dst].Router?
    requires machines[dst].router.state.WaitForEvents?
  {
    var (event, network') := network.receive(src, dst);

    var this_2 := this.(network := network');

    var this_1 := this_2.(machines := this_2.machines[dst := this_2.machines[dst].(router := this_2.machines[dst].router.(client := this_2.machines[dst].router.client[this_2.machines[dst].router.routerId * 1000 + |this_2.machines[dst].router.client| := payload.client]))]);

    var this_0 := this_1.(network := this_1.network.send(dst, Event.eClockTimeReq(tClockTimeReq.New(dst, this_1.machines[dst].router.routerId * 1000 + |this_1.machines[dst].router.client|)), this_1.machines[dst].router.localClock));

    this_0
  }

  function deliver_eClockTimeRsp_to_Router_in_WaitForEvents(src: MachineID, dst: MachineID, clock: tClockTimeRsp): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eClockTimeRsp?
    requires network.receive(src, dst).0.TClockTimeRsp == clock
    requires machines[dst].Router?
    requires machines[dst].router.state.WaitForEvents?
  {
    var (event, network') := network.receive(src, dst);

    var this_3 := this.(network := network');

    var this_2 := this_3.(machines := this_3.machines[dst := this_3.machines[dst].(router := this_3.machines[dst].router.(start_time := this_3.machines[dst].router.start_time[clock.requestId := clock.now.latest]))]);

    var this_1 := this_2.(machines := this_2.machines[dst := this_2.machines[dst].(router := this_2.machines[dst].router.(participants := this_2.machines[dst].router.participants[clock.requestId := {}]))]);

    var this_0 := this_1.(network := this_1.network.send(dst, Event.eStartRsp(tStartRsp.New(dst, clock.requestId, this_1.machines[dst].router.start_time[clock.requestId])), this_1.machines[dst].router.client[clock.requestId]));

    this_0
  }

  function deliver_eReadReq_to_Router_in_WaitForEvents(src: MachineID, dst: MachineID, read: tReadReq): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eReadReq?
    requires network.receive(src, dst).0.TReadReq == read
    requires machines[dst].Router?
    requires machines[dst].router.state.WaitForEvents?
  {
    var (event, network') := network.receive(src, dst);

    var this_1 := this.(network := network');

    var this_0 := this_1.(network := this_1.network.send(dst, Event.eShardReadReq(tShardReadReq.New(dst, read.tid, read.key, this_1.machines[dst].router.start_time[read.tid])), this_1.machines[dst].router.shards[key_shard(read.key, |this_1.machines[dst].router.shards|)]));

    this_0
  }

  function deliver_eShardReadRsp_to_Router_in_WaitForEvents(src: MachineID, dst: MachineID, read: tShardReadRsp): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eShardReadRsp?
    requires network.receive(src, dst).0.TShardReadRsp == read
    requires machines[dst].Router?
    requires machines[dst].router.state.WaitForEvents?
  {
    var (event, network') := network.receive(src, dst);

    var this_4 := this.(network := network');

    var this_3 := if read.status == tReqStatus.ABORT() then
                    var this_1 := multicastAbort(dst, read.tid);
                    var this_0 := this_1.(network := this_1.network.send(dst, Event.eReadRsp(tReadRsp.New(dst, read.tid, read.key, read.val, tReqStatus.ABORT())), this_1.machines[dst].router.client[read.tid]));
                    this_0 else
                    var this_2 := this_4.(network := this_4.network.send(dst, Event.eReadRsp(tReadRsp.New(dst, read.tid, read.key, read.val, tReqStatus.OK())), this_4.machines[dst].router.client[read.tid]));
                    this_2;

    this_3
  }

  function deliver_eUpdateReq_to_Router_in_WaitForEvents(src: MachineID, dst: MachineID, update: tUpdateReq): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eUpdateReq?
    requires network.receive(src, dst).0.TUpdateReq == update
    requires machines[dst].Router?
    requires machines[dst].router.state.WaitForEvents?
  {
    var (event, network') := network.receive(src, dst);

    var this_2 := this.(network := network');

    var this_1 := this_2.(machines := this_2.machines[dst := this_2.machines[dst].(router := this_2.machines[dst].router.(participants := this_2.machines[dst].router.participants[update.tid := this_2.machines[dst].router.participants[update.tid] + {this_2.machines[dst].router.shards[key_shard(update.key, |this_2.machines[dst].router.shards|)]}]))]);

    var this_0 := this_1.(network := this_1.network.send(dst, Event.eShardUpdateReq(tShardUpdateReq.New(dst, update.tid, update.key, update.val, this_1.machines[dst].router.start_time[update.tid])), this_1.machines[dst].router.shards[key_shard(update.key, |this_1.machines[dst].router.shards|)]));

    this_0
  }

  function deliver_eShardUpdateRsp_to_Router_in_WaitForEvents(src: MachineID, dst: MachineID, update: tShardUpdateRsp): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eShardUpdateRsp?
    requires network.receive(src, dst).0.TShardUpdateRsp == update
    requires machines[dst].Router?
    requires machines[dst].router.state.WaitForEvents?
  {
    var (event, network') := network.receive(src, dst);

    var this_4 := this.(network := network');

    var this_3 := if update.status == tReqStatus.ABORT() then
                    var this_1 := multicastAbort(dst, update.tid);
                    var this_0 := this_1.(network := this_1.network.send(dst, Event.eUpdateRsp(tUpdateRsp.New(dst, update.tid, update.key, update.val, tReqStatus.ABORT())), this_1.machines[dst].router.client[update.tid]));
                    this_0 else
                    var this_2 := this_4.(network := this_4.network.send(dst, Event.eUpdateRsp(tUpdateRsp.New(dst, update.tid, update.key, update.val, tReqStatus.OK())), this_4.machines[dst].router.client[update.tid]));
                    this_2;

    this_3
  }

  function deliver_eCommitReq_to_Router_in_WaitForEvents(src: MachineID, dst: MachineID, commit: tCommitReq, leader: MachineID): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eCommitReq?
    requires network.receive(src, dst).0.TCommitReq == commit
    requires machines[dst].Router?
    requires machines[dst].router.state.WaitForEvents?
    requires leader in this.machines[dst].router.shards.Values
  {
    var (event, network') := network.receive(src, dst);

    var this_6 := this.(network := network');

    var this_5 := this_6;

    var this_4 := this_5.(machines := this_5.machines[dst := this_5.machines[dst].(router := this_5.machines[dst].router.(lead_participant := this_5.machines[dst].router.lead_participant[commit.tid := leader]))]);

    var this_3 := this_4.(machines := this_4.machines[dst := this_4.machines[dst].(router := this_4.machines[dst].router.(prepare_responses := this_4.machines[dst].router.prepare_responses[commit.tid := {}]))]);

    var this_2 := this_3.(machines := this_3.machines[dst := this_3.machines[dst].(router := this_3.machines[dst].router.(prepare_commit_decision := this_3.machines[dst].router.prepare_commit_decision[commit.tid := true]))]);

    var this_1 := this_2.(machines := this_2.machines[dst := this_2.machines[dst].(router := this_2.machines[dst].router.(prepare_commit_time := this_2.machines[dst].router.prepare_commit_time[commit.tid := this_2.machines[dst].router.start_time[commit.tid]]))]);

    var this_0 := this_1.(network := this_1.network.multicast(dst, Event.eShardPrepareReq(tShardPrepareReq.New(dst, commit.tid, leader)), set shard: MachineID | shard in this_1.machines[dst].router.participants[commit.tid] && true :: shard));

    this_0
  }

  function deliver_eShardPrepareRsp_to_Router_in_WaitForEvents(src: MachineID, dst: MachineID, prepare: tShardPrepareRsp): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eShardPrepareRsp?
    requires network.receive(src, dst).0.TShardPrepareRsp == prepare
    requires machines[dst].Router?
    requires machines[dst].router.state.WaitForEvents?
  {
    var (event, network') := network.receive(src, dst);

    var this_8 := this.(network := network');

    var this_7 := this_8.(machines := this_8.machines[dst := this_8.machines[dst].(router := this_8.machines[dst].router.(prepare_responses := this_8.machines[dst].router.prepare_responses[prepare.tid := this_8.machines[dst].router.prepare_responses[prepare.tid] + {prepare}]))]);

    var this_6 := this_7.(machines := this_7.machines[dst := this_7.machines[dst].(router := this_7.machines[dst].router.(prepare_commit_decision := this_7.machines[dst].router.prepare_commit_decision[prepare.tid := this_7.machines[dst].router.prepare_commit_decision[prepare.tid] && prepare.status != tShardPrepareStatus.SHARD_ABORT()]))]);

    var this_5 := this_6.(machines := this_6.machines[dst := this_6.machines[dst].(router := this_6.machines[dst].router.(prepare_commit_time := this_6.machines[dst].router.prepare_commit_time[prepare.tid := max_time(this_6.machines[dst].router.prepare_commit_time[prepare.tid], prepare.prepare_time)]))]);

    var this_4 := if |this_5.machines[dst].router.prepare_responses[prepare.tid]| == |this_5.machines[dst].router.participants[prepare.tid]| then
                    var this_3 := if this_5.machines[dst].router.prepare_commit_decision[prepare.tid] then
                                    var this_0 := this_5.(network := this_5.network.send(dst, Event.eShardCommitReq(tShardCommitReq.New(dst, prepare.tid, this_5.machines[dst].router.prepare_commit_time[prepare.tid], this_5.machines[dst].router.participants[prepare.tid])), this_5.machines[dst].router.lead_participant[prepare.tid]));
                                    this_0 else
                                    var this_2 := multicastAbort(dst, prepare.tid);
                                    var this_1 := this_2.(network := this_2.network.send(dst, Event.eCommitRsp(tCommitRsp.New(prepare.tid, tTxnStatus.ABORTED())), this_2.machines[dst].router.client[prepare.tid]));
                                    this_1;
                    this_3 else
                    this_5;

    this_4
  }

  function deliver_eShardCommitRsp_to_Router_in_WaitForEvents(src: MachineID, dst: MachineID, commit: tShardCommitRsp): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eShardCommitRsp?
    requires network.receive(src, dst).0.TShardCommitRsp == commit
    requires machines[dst].Router?
    requires machines[dst].router.state.WaitForEvents?
  {
    var (event, network') := network.receive(src, dst);

    var this_8 := this.(network := network');

    var this_7 := if commit.status == tTxnStatus.COMMITTED() then
                    var this_3 := this_8;
                    var this_2 := this_3.(machines := this_3.machines[dst := this_3.machines[dst].(router := this_3.machines[dst].router.(committed := this_3.machines[dst].router.committed + {commit.tid}))]);
                    var this_1 := this_2.(network := this_2.network.multicast(dst, Event.eShardCommit(tShardCommit.New(commit.tid, commit.commit_time)), set shard: MachineID | shard in this_2.machines[dst].router.participants[commit.tid] && true :: shard));
                    var this_0 := this_1.(network := this_1.network.send(dst, Event.eCommitRsp(tCommitRsp.New(commit.tid, tTxnStatus.COMMITTED())), this_1.machines[dst].router.client[commit.tid]));
                    this_0 else
                    var this_6 := this_8;
                    var this_5 := multicastAbort(dst, commit.tid);
                    var this_4 := this_5.(network := this_5.network.send(dst, Event.eCommitRsp(tCommitRsp.New(commit.tid, tTxnStatus.ABORTED())), this_5.machines[dst].router.client[commit.tid]));
                    this_4;

    this_7
  }

  function deliver_eRollbackReq_to_Router_in_WaitForEvents(src: MachineID, dst: MachineID, rollback: tRollbackReq): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eRollbackReq?
    requires network.receive(src, dst).0.TRollbackReq == rollback
    requires machines[dst].Router?
    requires machines[dst].router.state.WaitForEvents?
  {
    var (event, network') := network.receive(src, dst);

    var this_2 := this.(network := network');

    var this_1 := multicastAbort(dst, rollback.tid);

    var this_0 := this_1.(network := this_1.network.send(dst, Event.eCommitRsp(tCommitRsp.New(rollback.tid, tTxnStatus.ABORTED())), this_1.machines[dst].router.client[rollback.tid]));

    this_0
  }

  function deliver_eDisconnectRouter_to_Router_in_WaitForEvents(src: MachineID, dst: MachineID, disconnect: tDisconnectRouter): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eDisconnectRouter?
    requires network.receive(src, dst).0.TDisconnectRouter == disconnect
    requires machines[dst].Router?
    requires machines[dst].router.state.WaitForEvents?
  {
    var (event, network') := network.receive(src, dst);

    var this_2 := this.(network := network');

    var this_1 := this_2.(network := this_2.network.send(dst, Event.eDisconnectRouterAck(tDisconnectRouterAck.New(dst)), disconnect.sender));

    var this_0 := this_1.(machines := this_1.machines[dst := this_1.machines[dst].(router := this_1.machines[dst].router.(state := RouterState.Disconnected(true)))]);

    this_0
  }

  function multicastAbort(dst: MachineID, tid: tTid): System
  {
    var this_0 := this.(network := this.network.multicast(dst, Event.eShardAbort(tShardAbort.New(tid)), set shard: MachineID | shard in this.machines[dst].router.participants[tid] && true :: shard));

    this_0
  }

  function deliver_eShardReadReq_to_Shard_in_WaitForRequests(src: MachineID, dst: MachineID, read: tShardReadReq): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eShardReadReq?
    requires network.receive(src, dst).0.TShardReadReq == read
    requires machines[dst].Shard?
    requires machines[dst].shard.state.WaitForRequests?
  {
    var (event, network') := network.receive(src, dst);

    var this_9 := this.(network := network');

    var this_8 := if read.tid in this_9.machines[dst].shard.aborted then
                    var this_1 := this_9.(network := this_9.network.send(dst, Event.eShardReadRsp(tShardReadRsp.New(dst, read.tid, read.key, INVALID_VALUE(), tReqStatus.ABORT())), read.router));
                    this_1 else
                    var this_7 := if read.tid in this_9.machines[dst].shard.write_buff && read.key in this_9.machines[dst].shard.write_buff[read.tid] then
                                    var this_2 := this_9.(network := this_9.network.send(dst, Event.eShardReadRsp(tShardReadRsp.New(dst, read.tid, read.key, this_9.machines[dst].shard.write_buff[read.tid][read.key], tReqStatus.OK())), read.router));
                                    this_2 else
                                    var this_6 := this_9.(machines := this_9.machines[dst := this_9.machines[dst].(shard := this_9.machines[dst].shard.(clock := max_time(this_9.machines[dst].shard.clock, read.start_time)))]);
                                    var this_5 := this_6.(machines := this_6.machines[dst := this_6.machines[dst].(shard := this_6.machines[dst].shard.(pending_reads := this_6.machines[dst].shard.pending_reads[read := {}]))]);
                                    var this_4 := this_5.(machines := this_5.machines[dst := this_5.machines[dst].(shard := this_5.machines[dst].shard.(pending_reads := this_5.machines[dst].shard.pending_reads[read := this_5.machines[dst].shard.pending_reads[read] + set tid: tTid | tid in this_5.machines[dst].shard.prepared && true && this_5.machines[dst].shard.prepared[tid] < read.start_time && tid in this_5.machines[dst].shard.write_buff && read.key in this_5.machines[dst].shard.write_buff[tid] :: tid]))]);
                                    var this_3 := this_4;
                                    this_3;
                    this_7;

    this_8
  }

  function deliver_eShardInquireRsp_to_Shard_in_WaitForRequests(src: MachineID, dst: MachineID, inquire: tShardInquireRsp): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eShardInquireRsp?
    requires network.receive(src, dst).0.TShardInquireRsp == inquire
    requires machines[dst].Shard?
    requires machines[dst].shard.state.WaitForRequests?
  {
    var (event, network') := network.receive(src, dst);

    var this_3 := this.(network := network');

    var this_2 := if inquire.read in this_3.machines[dst].shard.pending_reads && inquire.tid in this_3.machines[dst].shard.pending_reads[inquire.read] then
                    var this_1 := if !(inquire.status == tTxnStatus.COMMITTED() && inquire.commit_time < inquire.read.start_time) then
                                    var this_0 := this_3.(machines := this_3.machines[dst := this_3.machines[dst].(shard := this_3.machines[dst].shard.(pending_reads := this_3.machines[dst].shard.pending_reads[inquire.read := this_3.machines[dst].shard.pending_reads[inquire.read] - {inquire.tid}]))]);
                                    this_0 else
                                    this_3;
                    this_1 else
                    this_3;

    this_2
  }

  function deliver_eTriggerReadRsp_to_Shard_in_WaitForRequests(src: MachineID, dst: MachineID, read: tShardReadReq): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eTriggerReadRsp?
    requires machines[dst].Shard?
    requires machines[dst].shard.state.WaitForRequests?
    requires read in this.machines[dst].shard.pending_reads
  {
    var (event, network') := network.receive(src, dst);

    var this_5 := this.(network := network');

    var this_4 := if |this_5.machines[dst].shard.pending_reads| > 0 then
                    var this_3 := this_5;
                    var this_2 := if |this_3.machines[dst].shard.pending_reads[read]| == 0 then
                                    var this_1 := this_3.(machines := this_3.machines[dst := this_3.machines[dst].(shard := this_3.machines[dst].shard.(pending_reads := this_3.machines[dst].shard.pending_reads - {read}))]);
                                    var this_0 := this_1.(network := this_1.network.send(dst, Event.eShardReadRsp(tShardReadRsp.New(dst, read.tid, read.key, value_of_key_at_time(this_1.machines[dst].shard.versions, read.key, read.start_time), tReqStatus.OK())), read.router));
                                    this_0 else
                                    this_3;
                    this_2 else
                    this_5;

    this_4
  }

  function deliver_eShardUpdateReq_to_Shard_in_WaitForRequests(src: MachineID, dst: MachineID, update: tShardUpdateReq): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eShardUpdateReq?
    requires network.receive(src, dst).0.TShardUpdateReq == update
    requires machines[dst].Shard?
    requires machines[dst].shard.state.WaitForRequests?
  {
    var (event, network') := network.receive(src, dst);

    var this_6 := this.(network := network');

    var this_5 := if update.tid in this_6.machines[dst].shard.aborted then
                    var this_0 := this_6.(network := this_6.network.send(dst, Event.eShardUpdateRsp(tShardUpdateRsp.New(dst, update.tid, update.key, update.val, tReqStatus.ABORT())), update.router));
                    this_0 else
                    var this_4 := if update.tid in this_6.machines[dst].shard.write_buff && update.key in this_6.machines[dst].shard.write_buff[update.tid] then
                                    var this_2 := this_6.(machines := this_6.machines[dst := this_6.machines[dst].(shard := this_6.machines[dst].shard.(write_buff := this_6.machines[dst].shard.write_buff[update.tid := this_6.machines[dst].shard.write_buff[update.tid][update.key := update.val]]))]);
                                    var this_1 := this_2.(network := this_2.network.send(dst, Event.eShardUpdateRsp(tShardUpdateRsp.New(dst, update.tid, update.key, update.val, tReqStatus.OK())), update.router));
                                    this_1 else
                                    var this_3 := this_6.(machines := this_6.machines[dst := this_6.machines[dst].(shard := this_6.machines[dst].shard.(pending_updates := this_6.machines[dst].shard.pending_updates + {update}))]);
                                    this_3;
                    this_4;

    this_5
  }

  function deliver_eTriggerUpdateRsp_to_Shard_in_WaitForRequests(src: MachineID, dst: MachineID, update: tShardUpdateReq): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eTriggerUpdateRsp?
    requires machines[dst].Shard?
    requires machines[dst].shard.state.WaitForRequests?
    requires update in this.machines[dst].shard.pending_updates
  {
    var (event, network') := network.receive(src, dst);

    var this_13 := this.(network := network');

    var this_12 := if |this_13.machines[dst].shard.pending_updates| > 0 then
                     var this_11 := this_13;
                     var this_10 := if !(update.key in this_11.machines[dst].shard.locked_keys) then
                                      var this_9 := this_11.(machines := this_11.machines[dst := this_11.machines[dst].(shard := this_11.machines[dst].shard.(locked_keys := this_11.machines[dst].shard.locked_keys + {update.key}))]);
                                      var this_8 := if !(update.tid in this_9.machines[dst].shard.write_buff) then
                                                      var this_7 := this_9.(machines := this_9.machines[dst := this_9.machines[dst].(shard := this_9.machines[dst].shard.(write_buff := this_9.machines[dst].shard.write_buff[update.tid := map[]]))]);
                                                      this_7 else
                                                      this_9;
                                      var this_6 := if time_of_last_update(this_8.machines[dst].shard.versions, update.key) < update.start_time then
                                                      var this_1 := this_8.(machines := this_8.machines[dst := this_8.machines[dst].(shard := this_8.machines[dst].shard.(write_buff := this_8.machines[dst].shard.write_buff[update.tid := this_8.machines[dst].shard.write_buff[update.tid][update.key := update.val]]))]);
                                                      var this_0 := this_1.(network := this_1.network.send(dst, Event.eShardUpdateRsp(tShardUpdateRsp.New(dst, update.tid, update.key, update.val, tReqStatus.OK())), update.router));
                                                      this_0 else
                                                      var this_5 := this_8.(machines := this_8.machines[dst := this_8.machines[dst].(shard := this_8.machines[dst].shard.(locked_keys := this_8.machines[dst].shard.locked_keys - set key: tKey | key in this_8.machines[dst].shard.write_buff[update.tid] && true :: key))]);
                                                      var this_4 := this_5.(machines := this_5.machines[dst := this_5.machines[dst].(shard := this_5.machines[dst].shard.(write_buff := this_5.machines[dst].shard.write_buff - {update.tid}))]);
                                                      var this_3 := this_4.(machines := this_4.machines[dst := this_4.machines[dst].(shard := this_4.machines[dst].shard.(aborted := this_4.machines[dst].shard.aborted + {update.tid}))]);
                                                      var this_2 := this_3.(network := this_3.network.send(dst, Event.eShardUpdateRsp(tShardUpdateRsp.New(dst, update.tid, update.key, update.val, tReqStatus.ABORT())), update.router));
                                                      this_2;
                                      this_6 else
                                      this_11;
                     this_10 else
                     this_13;

    this_12
  }

  function deliver_eShardPrepareReq_to_Shard_in_WaitForRequests(src: MachineID, dst: MachineID, prepare: tShardPrepareReq): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eShardPrepareReq?
    requires network.receive(src, dst).0.TShardPrepareReq == prepare
    requires machines[dst].Shard?
    requires machines[dst].shard.state.WaitForRequests?
  {
    var (event, network') := network.receive(src, dst);

    var this_5 := this.(network := network');

    var this_4 := if prepare.tid in this_5.machines[dst].shard.aborted then
                    var this_0 := this_5.(network := this_5.network.send(dst, Event.eShardPrepareRsp(tShardPrepareRsp.New(dst, prepare.tid, tShardPrepareStatus.SHARD_ABORT(), INVALID_TIME())), prepare.router));
                    this_0 else
                    var this_3 := this_5.(machines := this_5.machines[dst := this_5.machines[dst].(shard := this_5.machines[dst].shard.(router := this_5.machines[dst].shard.router[prepare.tid := prepare.router]))]);
                    var this_2 := this_3.(machines := this_3.machines[dst := this_3.machines[dst].(shard := this_3.machines[dst].shard.(lead_shard := this_3.machines[dst].shard.lead_shard[prepare.tid := prepare.lead_participant]))]);
                    var this_1 := this_2.(network := this_2.network.send(dst, Event.eClockTimeReq(tClockTimeReq.New(dst, prepare.tid)), this_2.machines[dst].shard.localClock));
                    this_1;

    this_4
  }

  function deliver_eClockTimeRsp_to_Shard_in_WaitForRequests(src: MachineID, dst: MachineID, payload: tClockTimeRsp): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eClockTimeRsp?
    requires network.receive(src, dst).0.TClockTimeRsp == payload
    requires machines[dst].Shard?
    requires machines[dst].shard.state.WaitForRequests?
  {
    var (event, network') := network.receive(src, dst);

    var this_2 := this.(network := network');

    var this_1 := this_2.(machines := this_2.machines[dst := this_2.machines[dst].(shard := this_2.machines[dst].shard.(prepared := this_2.machines[dst].shard.prepared[payload.requestId := max_time(this_2.machines[dst].shard.clock, payload.now.latest)]))]);

    var this_0 := this_1.(network := this_1.network.send(dst, Event.eShardPrepareRsp(tShardPrepareRsp.New(dst, payload.requestId, tShardPrepareStatus.SHARD_OK(), max_time(this_1.machines[dst].shard.clock, payload.now.latest))), this_1.machines[dst].shard.router[payload.requestId]));

    this_0
  }

  function deliver_eShardCommit_to_Shard_in_WaitForRequests(src: MachineID, dst: MachineID, commit: tShardCommit): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eShardCommit?
    requires network.receive(src, dst).0.TShardCommit == commit
    requires machines[dst].Shard?
    requires machines[dst].shard.state.WaitForRequests?
  {
    var (event, network') := network.receive(src, dst);

    var this_8 := this.(network := network');

    var this_7 := if commit.tid in this_8.machines[dst].shard.write_buff then
                    var this_6 := this_8.(machines := this_8.machines[dst := this_8.machines[dst].(shard := this_8.machines[dst].shard.(versions := map key: tKey | key in this_8.machines[dst].shard.write_buff[commit.tid] && true :: key := this_8.machines[dst].shard.versions[key][commit.commit_time := this_8.machines[dst].shard.write_buff[commit.tid][key]]))]);
                    var this_5 := this_6.(machines := this_6.machines[dst := this_6.machines[dst].(shard := this_6.machines[dst].shard.(locked_keys := this_6.machines[dst].shard.locked_keys - set key: tKey | key in this_6.machines[dst].shard.write_buff[commit.tid] && true :: key))]);
                    var this_4 := this_5.(machines := this_5.machines[dst := this_5.machines[dst].(shard := this_5.machines[dst].shard.(write_buff := this_5.machines[dst].shard.write_buff - {commit.tid}))]);
                    this_4 else
                    this_8;

    var this_3 := if commit.tid in this_7.machines[dst].shard.prepared then
                    var this_2 := this_7.(machines := this_7.machines[dst := this_7.machines[dst].(shard := this_7.machines[dst].shard.(prepared := this_7.machines[dst].shard.prepared - {commit.tid}))]);
                    this_2 else
                    this_7;

    var this_1 := this_3.(machines := this_3.machines[dst := this_3.machines[dst].(shard := this_3.machines[dst].shard.(committed := this_3.machines[dst].shard.committed[commit.tid := commit.commit_time]))]);

    var this_0 := this_1.(machines := this_1.machines[dst := this_1.machines[dst].(shard := this_1.machines[dst].shard.(pending_reads := map read: tShardReadReq | read in this_1.machines[dst].shard.pending_reads && true && commit.tid in this_1.machines[dst].shard.pending_reads[read] :: read := this_1.machines[dst].shard.pending_reads[read] - {commit.tid}))]);

    this_0
  }

  function deliver_eShardAbort_to_Shard_in_WaitForRequests(src: MachineID, dst: MachineID, abort: tShardAbort): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eShardAbort?
    requires network.receive(src, dst).0.TShardAbort == abort
    requires machines[dst].Shard?
    requires machines[dst].shard.state.WaitForRequests?
  {
    var (event, network') := network.receive(src, dst);

    var this_7 := this.(network := network');

    var this_6 := if abort.tid in this_7.machines[dst].shard.write_buff then
                    var this_5 := this_7.(machines := this_7.machines[dst := this_7.machines[dst].(shard := this_7.machines[dst].shard.(locked_keys := this_7.machines[dst].shard.locked_keys - set key: tKey | key in this_7.machines[dst].shard.write_buff[abort.tid] && true :: key))]);
                    var this_4 := this_5.(machines := this_5.machines[dst := this_5.machines[dst].(shard := this_5.machines[dst].shard.(write_buff := this_5.machines[dst].shard.write_buff - {abort.tid}))]);
                    this_4 else
                    this_7;

    var this_3 := if abort.tid in this_6.machines[dst].shard.prepared then
                    var this_2 := this_6.(machines := this_6.machines[dst := this_6.machines[dst].(shard := this_6.machines[dst].shard.(prepared := this_6.machines[dst].shard.prepared - {abort.tid}))]);
                    this_2 else
                    this_6;

    var this_1 := this_3.(machines := this_3.machines[dst := this_3.machines[dst].(shard := this_3.machines[dst].shard.(aborted := this_3.machines[dst].shard.aborted + {abort.tid}))]);

    var this_0 := this_1.(machines := this_1.machines[dst := this_1.machines[dst].(shard := this_1.machines[dst].shard.(pending_reads := map read: tShardReadReq | read in this_1.machines[dst].shard.pending_reads && true && abort.tid in this_1.machines[dst].shard.pending_reads[read] :: read := this_1.machines[dst].shard.pending_reads[read] - {abort.tid}))]);

    this_0
  }

  function deliver_eShardCommitReq_to_Shard_in_WaitForRequests(src: MachineID, dst: MachineID, commit: tShardCommitReq): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eShardCommitReq?
    requires network.receive(src, dst).0.TShardCommitReq == commit
    requires machines[dst].Shard?
    requires machines[dst].shard.state.WaitForRequests?
  {
    var (event, network') := network.receive(src, dst);

    var this_5 := this.(network := network');

    var this_4 := if commit.tid in this_5.machines[dst].shard.aborted then
                    var this_0 := this_5.(network := this_5.network.send(dst, Event.eShardCommitRsp(tShardCommitRsp.New(dst, commit.tid, tTxnStatus.ABORTED(), INVALID_TIME())), commit.router));
                    this_0 else
                    var this_3 := this_5.(machines := this_5.machines[dst := this_5.machines[dst].(shard := this_5.machines[dst].shard.(committed := this_5.machines[dst].shard.committed[commit.tid := max_time(this_5.machines[dst].shard.clock, commit.max_prepare_time)]))]);
                    var this_2 := this_3.(machines := this_3.machines[dst := this_3.machines[dst].(shard := this_3.machines[dst].shard.(router := this_3.machines[dst].shard.router[commit.tid := commit.router]))]);
                    var this_1 := this_2.(network := this_2.network.send(dst, Event.eClockAlarmReq(tClockAlarmReq.New(dst, commit.tid, max_time(this_2.machines[dst].shard.clock, commit.max_prepare_time))), this_2.machines[dst].shard.localClock));
                    this_1;

    this_4
  }

  function deliver_eClockAlarmRsp_to_Shard_in_WaitForRequests(src: MachineID, dst: MachineID, alarm: tClockAlarmRsp): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eClockAlarmRsp?
    requires network.receive(src, dst).0.TClockAlarmRsp == alarm
    requires machines[dst].Shard?
    requires machines[dst].shard.state.WaitForRequests?
  {
    var (event, network') := network.receive(src, dst);

    var this_8 := this.(network := network');

    var this_7 := if alarm.requestId in this_8.machines[dst].shard.write_buff then
                    var this_6 := this_8.(machines := this_8.machines[dst := this_8.machines[dst].(shard := this_8.machines[dst].shard.(versions := map key: tKey | key in this_8.machines[dst].shard.write_buff[alarm.requestId] && true :: key := this_8.machines[dst].shard.versions[key][this_8.machines[dst].shard.committed[alarm.requestId] := this_8.machines[dst].shard.write_buff[alarm.requestId][key]]))]);
                    var this_5 := this_6.(machines := this_6.machines[dst := this_6.machines[dst].(shard := this_6.machines[dst].shard.(locked_keys := this_6.machines[dst].shard.locked_keys - set key: tKey | key in this_6.machines[dst].shard.write_buff[alarm.requestId] && true :: key))]);
                    var this_4 := this_5.(machines := this_5.machines[dst := this_5.machines[dst].(shard := this_5.machines[dst].shard.(write_buff := this_5.machines[dst].shard.write_buff - {alarm.requestId}))]);
                    this_4 else
                    this_8;

    var this_3 := if alarm.requestId in this_7.machines[dst].shard.prepared then
                    var this_2 := this_7.(machines := this_7.machines[dst := this_7.machines[dst].(shard := this_7.machines[dst].shard.(prepared := this_7.machines[dst].shard.prepared - {alarm.requestId}))]);
                    this_2 else
                    this_7;

    var this_1 := this_3.(machines := this_3.machines[dst := this_3.machines[dst].(shard := this_3.machines[dst].shard.(pending_reads := map read: tShardReadReq | read in this_3.machines[dst].shard.pending_reads && true && alarm.requestId in this_3.machines[dst].shard.pending_reads[read] :: read := this_3.machines[dst].shard.pending_reads[read] - {alarm.requestId}))]);

    var this_0 := this_1.(network := this_1.network.send(dst, Event.eShardCommitRsp(tShardCommitRsp.New(dst, alarm.requestId, tTxnStatus.COMMITTED(), this_1.machines[dst].shard.committed[alarm.requestId])), this_1.machines[dst].shard.router[alarm.requestId]));

    this_0
  }

  function deliver_eShardInquireReq_to_Shard_in_WaitForRequests(src: MachineID, dst: MachineID, inquire: tShardInquireReq): System
    requires src in machines
    requires dst in machines
    requires network.receivable(src, dst)
    requires network.receive(src, dst).0.eShardInquireReq?
    requires network.receive(src, dst).0.TShardInquireReq == inquire
    requires machines[dst].Shard?
    requires machines[dst].shard.state.WaitForRequests?
  {
    var (event, network') := network.receive(src, dst);

    var this_4 := this.(network := network');

    var this_3 := if inquire.tid in this_4.machines[dst].shard.committed then
                    var this_0 := this_4.(network := this_4.network.send(dst, Event.eShardInquireRsp(tShardInquireRsp.New(inquire.tid, tTxnStatus.COMMITTED(), this_4.machines[dst].shard.committed[inquire.tid], inquire.read)), inquire.shard));
                    this_0 else
                    var this_2 := this_4.(machines := this_4.machines[dst := this_4.machines[dst].(shard := this_4.machines[dst].shard.(clock := max_time(this_4.machines[dst].shard.clock, inquire.read.start_time)))]);
                    var this_1 := this_2.(network := this_2.network.send(dst, Event.eShardInquireRsp(tShardInquireRsp.New(inquire.tid, tTxnStatus.ACTIVE(), INVALID_TIME(), inquire.read)), inquire.shard));
                    this_1;

    this_3
  }
}