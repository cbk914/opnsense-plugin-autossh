{#
    Copyright (c) 2018 Verb Networks Pty Ltd <contact@verbnetworks.com>
    Copyright (c) 2018 Nicholas de Jong <me@nicholasdejong.com>
    All rights reserved.

    Redistribution and use in source and binary forms, with or without modification,
    are permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice, this
       list of conditions and the following disclaimer.

    2. Redistributions in binary form must reproduce the above copyright notice,
       this list of conditions and the following disclaimer in the documentation
       and/or other materials provided with the distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
    ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
    ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#}

<div class="alert alert-info hidden" role="alert" id="responseMsg"></div>

<ul class="nav nav-tabs" data-tabs="tabs" id="maintabs">
    <li class="active"><a data-toggle="tab" href="#tunnels">{{ lang._('Tunnels') }}</a></li>
    <li><a data-toggle="tab" href="#keys">{{ lang._('Keys') }}</a></li>
    <li><a data-toggle="tab" href="#about">{{ lang._('About') }}</a></li>
</ul>

<div class="tab-content content-box tab-content">
    <div id="tunnels" class="tab-pane fade in active">
        <div class="content-box" style="padding-bottom: 1.5em;">
            {{ partial("layout_partials/base_form",['fields':tunnelsForm,'id':'frm_Tunnels'])}}
            <div class="col-md-12">
                <hr />
                <button class="btn btn-primary" id="saveAction" type="button"><b>{{ lang._('Save') }}</b> <i id="saveAct_progress"></i></button>
                <button class="btn btn-primary"  id="testAction" type="button"><b>{{ lang._('Test Credentials') }}</b></button>
            </div>
        </div>
    </div>

    <div id="keys" class="tab-pane fade in">
        <table id="grid-keys" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="DialogKeys" data-keyDialog="DialogKeyDetails">
            <thead>
            <tr>
                <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                <th data-column-id="name" data-type="string" data-visible="true">{{ lang._('Name') }}</th>
                <th data-column-id="key_fingerprint" data-type="string" data-visible="true">{{ lang._('SSH Key Fingerprint') }}</th>
                <th data-column-id="type" data-width="8em" data-type="string" data-visible="true">{{ lang._('Type') }}</th>
                <th data-column-id="timestamp" data-width="14em" data-type="string" data-visible="true">{{ lang._('Created') }}</th>
                <th data-column-id="commands" data-width="7em"   data-formatter="commands" data-sortable="false">{{ lang._('Commands') }}</th>
            </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
            <tr>
                <td></td>
                <td>
                    <button data-action="add" type="button" class="btn btn-xs btn-default"><span class="fa fa-plus"></span></button>
                    <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button>
                </td>
            </tr>
            </tfoot>
        </table>
    </div>
    
    <div id="about" class="tab-pane fade in">
        <div class="content-box" style="padding-bottom: 1.5em;">

            <div  class="col-md-12">
                <h1>Autossh</h1>
                <p>
                    Hello world
                </p>

                <p>
                    Note to self
                </p>
                <ul>
                    <li>https://gist.github.com/qingshan/1573576</li>
                    <li>https://gist.github.com/maratsh/3689120</li>
                    <li>https://gist.github.com/haku/6322759</li>
                </ul>


                <hr />
                
                <h1>Author</h1>
                <p>Autossh is a Verb Networks plugin for OPNsense - we make other tools for OPNsense too!</p>

                <h1>License</h1>
                <p>BSD-2-Clause - see LICENSE file for full details.</p>

                <h1>Copyright</h1>
                <p>Copyright 2018 - All rights reserved - <a href="https://verbnetworks.com/">Verb Networks Pty Ltd</a></p>
                
            </div>

        </div>
    </div>
</div>

{# include dialogs #}
{{ partial("layout_partials/base_dialog",['fields':formDialogKeys,'id':'DialogKeys','label':lang._('SSH key')])}}

<style>
    div.type-info div.modal-dialog div.modal-body div.bootstrap-dialog-message {
        font-size: 100%;
        font-family: Menlo, Monaco, Consolas, "Courier New", monospace;
        word-break: break-all;  
    }
</style>

<script>
    
    $(document).ready(function() {
        
        $("#grid-keys").UIBootgrid(
            {   search:'/api/autossh/keys/search',
                get:'/api/autossh/keys/get/',
                set:'/api/autossh/keys/set/',
                add:'/api/autossh/keys/add/',
                del:'/api/autossh/keys/del/',
                info:'/api/autossh/keys/info/',
                
                options:{
                    //requestHandler:addRuleFilters,
                    rowCount:[10, 25, 100, -1] ,
                    formatters:{
                        commands: function (column, row) {
                            return  "<button type=\"button\" class=\"btn btn-xs btn-default command-info\" data-row-id=\"" + row.uuid + "\"><span class=\"fa fa-key\"></span></button> " +
                                    "<button type=\"button\" class=\"btn btn-xs btn-default command-edit\" data-row-id=\"" + row.uuid + "\"><span class=\"fa fa-pencil\"></span></button> " +
                                    "<button type=\"button\" class=\"btn btn-xs btn-default command-delete\" data-row-id=\"" + row.uuid + "\"><span class=\"fa fa-trash-o\"></span></button>";
                        }
                    }
                },                
            },
        );
        
        $("#DialogKeys").change(function() {
            if($('#key\\.key_fingerprint').text().length >= 1) {
                $('#row_key\\.type div.btn-group button.dropdown-toggle').attr('data-toggle', '');
            } else {
                $('#row_key\\.type div.btn-group button.dropdown-toggle').attr('data-toggle', 'dropdown');
            }
        });

        formatTokenizersUI();
        $('.selectpicker').selectpicker('refresh');

    });
</script>
