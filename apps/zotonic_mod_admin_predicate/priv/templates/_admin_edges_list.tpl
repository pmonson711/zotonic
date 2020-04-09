<table class="table table-striped do_adminLinkedTable">
    <thead>
        <tr>
            <th width="35%">
                {_ Subject _}
            </th>
            <th width="30%">
                {_ Predicate _} &rarr;
            </th>
            <th width="35%">
                {_ Object _}
            </th>
        </tr>
    </thead>

    <tbody>
    {% for edge in result %}
        {% with edge.id as id %}
        {% if edge.subject_id.is_visible or edge.object_id.is_visible %}
        <tr id="{{ #tr.id }}">
            <td class="{% if not edge.subject_id.is_published %}unpublished{% endif %}" data-href="{% url admin_edit_rsc id=edge.subject_id %}">
                {% catinclude "_rsc_item.tpl" edge.subject_id show_medium %}
            </td>
            <td class="clickable">
                <strong>
                    <span {% include "_language_attrs.tpl" %}>{{ edge.predicate_id.title }}</span>
                    {% if m.acl.is_allowed.link[edge.subject_id] %}
                        <button id="{{ #unlink.id }}" class="btn btn-xs btn-default">{_ Disconnect _}</button>
                        {% wire id=#unlink.id
                            action={confirm
                                text=[_"Are you sure you want to disconnect: ", edge.object_id.title, "?" ]
                                ok=_"Disconnect"
                                action={unlink
                                    subject_id=edge.subject_id
                                    edge_id=edge.id
                                    hide=#tr.id
                                }
                            }
                        %}
                    {% endif %}
                </strong><br/>
                <div class="text-muted">
                    <span class="edge-date">
                        {{ edge.created|date:_"d M Y, H:i" }}
                    </span>
                    {% with edge.creator_id as creator_id %}
                        {% if creator_id %}
                            {_ by _}
                            <a class="edge-creator" href="{% url admin_edit_rsc id=creator_id %}">
                                {% include "_name.tpl" id=creator_id %}
                            </a>
                        {% endif %}
                    {% endwith %}
                </div>
            </td>
            <td class="{% if not edge.object_id.is_published %}unpublished{% endif %}" data-href="{% url admin_edit_rsc id=edge.object_id %}">
                {% catinclude "_rsc_item.tpl" edge.object_id show_medium %}
            </td>
        </tr>
        {% endif %}
        {% endwith %}
    {% empty %}
        <tr>
            <td colspan="5">
                {% if q.qpredicate %}
                    {_ No page connections with the predicate: _} {{ m.rsc[q.qpredicate].title }}
                {% else %}
                    {_ No page connections found. _}
                {% endif %}
            </td>
        </tr>
    {% endfor %}
    </tbody>
</table>
