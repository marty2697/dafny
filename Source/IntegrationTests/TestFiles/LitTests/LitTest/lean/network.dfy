// LIBRARY

datatype Link = Link(src: MachineID, dst: MachineID)

datatype Channel = Channel(msgs: seq<Event>) {
  predicate empty() {|msgs| == 0}
  predicate nonempty() {!empty()}
  predicate init() {empty()}
  static function New(): Channel ensures New().init() { Channel(msgs := [])}

  function send(msg: Event): Channel {this.(msgs := msgs + [msg])}
  function receive(): (Event, Channel) requires nonempty() {(msgs[0], this.(msgs := msgs[1..]))}
  function drop(idx: nat): Channel {if idx < |msgs| then this.(msgs := msgs[..idx] + msgs[idx+1..]) else this}
}

datatype Network = Network(channel: map<Link, Channel>) {
  predicate init() {forall link <- channel :: channel[link].init()}
  static function New(): Network ensures New().init() {Network.Network(channel := map[])}

  predicate receivable (src: MachineID, dst: MachineID)
  {
    var link := Link(src, dst);
    link in channel && channel[link].nonempty()
  }

  function ensure(link: Link): (res: Network)
    ensures link in res.channel
    ensures link in channel ==> res.channel[link] == channel[link]
    ensures link !in channel ==> res.channel[link].empty()
  {
    if link in channel then this else this.(channel := channel[link := Channel.New()])
  }

  function send(src: MachineID, msg: Event, dst: MachineID): Network
  {
    var link := Link(src, dst);
    this.(channel := channel[link := ensure(link).channel[link].send(msg)])
  }

  function receive(src: MachineID, dst: MachineID): (Event, Network)
    requires receivable(src, dst)
  {
    var link := Link(src, dst);
    var (msg, ch) := channel[link].receive();
    (msg, this.(channel := channel[link := ch]))
  }

  function peek (src: MachineID, dst: MachineID): Event
    requires receivable(src, dst)
  {
    channel[Link(src, dst)].msgs[0]
  }

  function multicast(src: MachineID, event: Event, targets: set<MachineID>): Network {
    Network(
      map link <- channel ::
        if link.src == src && link.dst in targets then
          Channel(channel[link].msgs + [event])
        else
          channel[link]
    )
  }

  function multisend(src: MachineID, msgs: set<(MachineID, Event)>): Network {
    if |msgs| == 0 then this else
    var msg: (MachineID, Event) :| msg in  msgs;
    this.send(src, msg.1, msg.0).multisend(src, msgs - {msg})
  }
}
